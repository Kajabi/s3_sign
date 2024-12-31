# frozen_string_literal: true

require "s3_sign/version"
require "s3_sign/helper"
require "aws-sdk-s3"

module S3Sign
  SEVEN_DAYS = 60 * 60 * 24 * 7

  class << self
    attr_writer :bucket_name

    def bucket_name
      @bucket_name or raise "No S3Sign.bucket_name is set"
    end
  end

  def self.url(s3_url, options = {})
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(bucket_name)
    path = path_from_s3_url(s3_url)
    obj = bucket.object(path)
    obj.presigned_url(:get, **build_options(options))
  end

  def self.build_options(options)
    { expires_in: options.fetch(:expires, SEVEN_DAYS).to_i }.tap do |o|
      attachment_filename = options[:attachment_filename]

      o[:response_content_disposition] = "attachment; filename=#{attachment_filename}" if attachment_filename
    end
  end

  def self.path_from_s3_url(s3_url)
    s3_url.sub(%r{^.+?/#{bucket_name}/}, "")
  end
end
