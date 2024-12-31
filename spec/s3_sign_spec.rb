# frozen_string_literal: true

require "spec_helper"

describe S3Sign do
  before do
    Aws.config.update(credentials: Aws::Credentials.new("spec_access_key_id", "spec_secret_access_key"))

    described_class.bucket_name = "spec_bucket"
  end

  describe ".url" do
    it "raises a runtime error if the bucket_name is not set" do
      described_class.bucket_name = nil
      expect(lambda {
        described_class.url("foo.png")
      }).to raise_error(RuntimeError, "No S3Sign.bucket_name is set")
    end

    it "signs a given url for the bucket name with expiration and signature" do
      bucket = described_class.bucket_name
      access_key = "spec_access_key_id"

      url = "https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg"
      signed = described_class.url(url)
      expect(signed).to match(%r{^https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg\?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=#{access_key}%2F\d+%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=\w+&X-Amz-Expires=\d+&X-Amz-SignedHeaders=host&X-Amz-Signature=\w+$})
    end

    it "can receive an optional expires value" do
      bucket = described_class.bucket_name
      access_key = "spec_access_key_id"

      url = "https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg"
      signed = described_class.url(url, expires: 42)
      expect(signed).to match(%r{^https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg\?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=#{access_key}%2F\d+%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=\w+&X-Amz-Expires=42&X-Amz-SignedHeaders=host&X-Amz-Signature=\w+$})
    end

    it "adds response_content_type for the given attachment_filename if present" do
      bucket = described_class.bucket_name

      url = "https://s3.amazonaws.com/#{bucket}/accounts/2/products/1234.jpg"
      signed = described_class.url(url, attachment_filename: "photo.jpg")
      expect(signed).to match(%r{^https://s3.amazonaws.com/#{bucket}/accounts/2/products/1234.jpg\?.*response-content-disposition=attachment%3B%20filename%3Dphoto.jpg})
    end
  end
end
