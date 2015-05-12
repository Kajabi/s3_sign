require "s3_sign/version"
require "s3_sign/helper"
require "aws"

module S3Sign
  SEVEN_DAYS = 60 * 60 * 24 * 7

  class << self
    attr_writer :bucket_name
    def bucket_name
      @bucket_name or raise "No S3Sign.bucket_name is set"
    end
  end

  def self.url(s3_url, options = {})
    s3 = AWS::S3.new
    bucket = s3.buckets[bucket_name]

    path = path_from_s3_url(s3_url)

    AWS::S3::S3Object.new(bucket, path).url_for(:read, build_options(options)).to_s
  end

  protected

  def self.build_options(options)
    { expires: options.fetch(:expires, SEVEN_DAYS) }.tap do |o|
      attachment_name = options[:attachment_name]

      if attachment_name
        o[:response_content_disposition] = "attachment; filename=#{attachment_name}"
      end
    end
  end

  def self.path_from_s3_url(s3_url)
    s3_url.sub(%r{^.+?/#{bucket_name}/}, '')
  end
end
