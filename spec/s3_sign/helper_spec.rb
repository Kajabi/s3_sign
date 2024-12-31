# frozen_string_literal: true

require "spec_helper"

describe S3Sign::Helper do
  include described_class

  before do
    s3 = Aws::S3::Client.new(stub_responses: true)
    s3.stub_responses(:presign_url, ->(context) { { url: "https://example.com/#{context.params[:key]}" } })
    allow(Aws::S3::Client).to receive(:new).with(any_args).and_return(s3)
  end

  describe "#s3_signed_url_for_key" do
    it "calls S3Sign.url with the given key and expires in" do
      allow(S3Sign).to receive(:url).with("test.txt", hash_including(expires: 86_400)).and_return(:url_one)
      expect(s3_signed_url_for_key("test.txt")).to eq(:url_one)
    end

    it "calls S3Sign.url with the another key and expires in" do
      allow(S3Sign).to receive(:url).with("test.pdf", hash_including(expires: 3600)).and_return(:url_two)
      expect(s3_signed_url_for_key("test.pdf", expires: 3600)).to eq(:url_two)
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
