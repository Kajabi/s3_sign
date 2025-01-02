# frozen_string_literal: true

require "spec_helper"

describe S3Sign::Helper do
  include described_class

  before do
    s3 = Aws::S3::Client.new(stub_responses: true)
    S3Sign.bucket_name = "example-bucket"
    allow(Aws::S3::Client).to receive(:new).with(any_args).and_return(s3)
  end

  describe "#s3_signed_url_for_key" do
    it "returns a presigned url for the given bucket with the given key" do
      expect(s3_signed_url_for_key("test.txt")).to start_with("https://example-bucket.s3.us-stubbed-1.amazonaws.com/test.txt")
    end

    it "returns a presigned url with the default expires in" do
      expect(s3_signed_url_for_key("test.txt")).to include("X-Amz-Expires=86400")
    end

    it "returns a presigned url with the custom expires" do
      expect(s3_signed_url_for_key("test.pdf", expires: 3600)).to include("X-Amz-Expires=3600")
    end
  end

  describe "#stable_s3_signed_url" do
    it "signs with a default far future expires time of 2036-1-1 00:00:00 UTC" do
      allow(S3Sign).to receive(:url).with("test.txt",
                                          hash_including(expires: Time.parse("2036-01-01 00:00:00 UTC")))
                                    .and_return(:url)
      expect(stable_s3_signed_url("test.txt")).to eq(:url)
    end

    it "signs for a given time in 2036 if given a reference time" do
      allow(S3Sign).to receive(:url).with("test.txt",
                                          hash_including(expires: Time.parse("2036-03-24 21:47:30 UTC")))
                                    .and_return(:url)
      expect(stable_s3_signed_url("test.txt", expires: Time.parse("2015-03-24 21:47:30 UTC"))).to eq(:url)
    end
  end
end
