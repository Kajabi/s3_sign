require "spec_helper"

describe S3Sign, '.url' do
  before do
    AWS.config(
      :access_key_id     => "spec_access_key_id",
      :secret_access_key => "spec_secret_access_key"
    )

    S3Sign.bucket_name = "spec_bucket"
  end

  it "raises a runtime error if the bucket_name is not set" do
    S3Sign.bucket_name = nil
    expect(lambda {
      S3Sign.url("foo.png")
    }).to raise_error(RuntimeError, "No S3Sign.bucket_name is set")
  end

  it "signs a given url for the bucket name with expiration and signature" do
    bucket = S3Sign.bucket_name
    access_key = "spec_access_key_id"

    url = "https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg"
    signed = S3Sign.url(url)
    expect(signed).to match(%r{^https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg\?AWSAccessKeyId=#{access_key}&Expires=\d+&Signature=.+%3D$})
  end

  it "can receive an optional expires value" do
    bucket = S3Sign.bucket_name
    access_key = "spec_access_key_id"

    url = "https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg"
    signed = S3Sign.url(url, expires: 42)
    expires_timestamp = (Time.now + 42).to_i
    expect(signed).to match(%r{^https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg\?AWSAccessKeyId=#{access_key}&Expires=#{expires_timestamp}&Signature=.+%3D$})
  end

  it "will add response_content_type for the given attachment_filename if present" do
    bucket = S3Sign.bucket_name
    access_key = "spec_access_key_id"

    url = "https://s3.amazonaws.com/#{bucket}/accounts/2/products/1234.jpg"
    signed = S3Sign.url(url, attachment_filename: "photo.jpg")
    expect(signed).to match(%r{^https://s3.amazonaws.com/#{bucket}/accounts/2/products/1234.jpg\?.*response-content-disposition=attachment%3B%20filename%3Dphoto.jpg})
  end
end
