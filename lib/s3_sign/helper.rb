# frozen_string_literal: true

require "time"

module S3Sign
  # The S3Sign::Helper module provides two methods for generating S3 signed URLs with different caching strategies,
  # designed to be included in Rails controllers.
  module Helper
    def self.included(base)
      if base.respond_to?(:helper_method)
        base.helper_method :stable_s3_signed_url
        base.helper_method :s3_signed_url_for_key
      end

      return unless base.respond_to?(:hide_action)

      base.hide_action :stable_s3_signed_url
      base.hide_action :s3_signed_url_for_key
    end

    # A pure "time from now" signed s3 asset url.  Good for non-visual elements
    # like attachments, and not thumbnails, that don't have the same caching concerns
    def s3_signed_url_for_key(key, options = {})
      options[:expires] ||= 86_400
      S3Sign.url key, options
    end

    # Uses a far-future date so that the expires and signature on
    # the url doesn't change for every request.  This lets us still
    # protect assets but the browser can cache them because the url
    # isn't constantly changing.
    #
    # Use for assets we want browser cached that don't need higher
    # level protection, such as thumbnails.  Other more central assets
    # like downloads for a course or videos should have short expiration
    # because they generally don't benefit as much from caching and need
    # better time-based protection.
    #
    # If a reference_time is given, that will use the time given but in the
    # far future stable year.  This is useful to cache-bust the url from
    # an updated_at timestamp where some browsers/proxies may try to use
    # the cached asset even though it was updated.
    def stable_s3_signed_url(url, options = {})
      @stable_s3_expire_at ||= Time.parse("2036-1-1 00:00:00 UTC")

      if (reference_time = options.delete(:expires))
        # The time given but in the year 2036
        year       = @stable_s3_expire_at.year
        expires_at = Time.parse(reference_time.utc.strftime("#{year}-%m-%d %T UTC"))
      else
        expires_at = @stable_s3_expire_at
      end

      s3_signed_url_for_key(url, expires: expires_at)
    end
  end
end
