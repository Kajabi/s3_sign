# S3Sign

S3Sign allows easy signing of already formatted s3 urls.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_sign'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_sign

## Usage

Initialize the `bucket_name` for for `S3Sign`.  In rails for instance,
you might add an initializer for this.

### Setup
```ruby
S3Sign.bucket_name = "super_s3_bucket"
```

The gem assumes you already have AWS (via aws-sdk) [configured globally](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html),
something like this:

```ruby
Aws.config.update({
  credentials: Aws::Credentials.new(AppConfig.aws.access_key, AppConfig.aws.secret_key)
})
```

### API

The `S3Sign` module itself provides `.url`:

```ruby
# Pass a full s3 url and 1 hour expiration
S3Sign.url "http://s3.amazonaws.com/bucket/foo.png", expires: 3600
# => "https://bucket.s3.amazonaws.com/foo.png?AWSAccessKeyId=access_key_id&Expires=1427243780&Signature=a3RzDgElxDpSZLgxurZLiw1a6Ny%3D"

# Pass a 'key' portion found under the bucket with default expiration
S3Sign.url "images/foo.png"
```

The gem also provides a `S3Sign::Helper` module, useful to mixin to rails
controllers.  It will add two helper methods to your controllers and views.

`s3_signed_url_for_key` - Takes a key/url and options

`stable_s3_signed_url` - Takes a url and options.  Used for
generating signatures that expire in the far future year 2036.

## Contributing

1. Fork it ( https://github.com/Kajabi/s3_sign/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Release

If you are looking to contribute in the gem you need to be aware that we are using the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) specification to release versions in this gem.

which means, when doing a contribution your commit message must have the following structure

```git
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

[here](https://www.conventionalcommits.org/en/v1.0.0/#examples) you can find some commit's examples.
