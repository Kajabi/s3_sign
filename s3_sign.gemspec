# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "s3_sign/version"

Gem::Specification.new do |spec|
  spec.name          = "s3_sign"
  spec.version       = S3Sign::VERSION
  spec.authors       = ["Brendon Murphy"]
  spec.email         = ["xternal1+github@gmail.com"]

  spec.summary       = "A quick a dirty way to s3 sign string s3 urls using the aws-sdk"
  spec.description   = "A quick a dirty way to s3 sign string s3 urls using the aws-sdk"
  spec.homepage      = "https://github.com/Kajabi/s3_sign"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-s3", "~> 1"

  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rubocop", "~> 1.69"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
  spec.metadata["rubygems_mfa_required"] = "true"
end
