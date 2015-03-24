require "spec_helper"

describe S3Sign, '.url' do
  before do
    AWS.config(
      :access_key_id     => "spec_access_key_id",
      :secret_access_key => "spec_secret_access_key"
    )

    S3Sign.bucket_name = "spec_bucket"
  end

  it "signs a given url for the bucket name with expiration and signature" do
    bucket = S3Sign.bucket_name
    access_key = "spec_access_key_id"

    url = "https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg"
    signed = S3Sign.url(url)
    expect(signed).to match(%r{^https://s3.amazonaws.com/#{bucket}/accounts/2/products/photo.jpg\?AWSAccessKeyId=#{access_key}&Expires=\d+&Signature=.+%3D$})
  end
end
