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

  def self.url(s3_url, expires = SEVEN_DAYS)
    s3 = AWS::S3.new
    bucket = s3.buckets[bucket_name]

    path = path_from_s3_url(s3_url)

    AWS::S3::S3Object.new(bucket, path).url_for(:read, expires: expires).to_s
  end

  protected

  def self.path_from_s3_url(s3_url)
    s3_url.sub(%r{^.+?/#{bucket_name}/}, '')
  end
end
