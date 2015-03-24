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

The gem assumes you already have AWS (via aws-sdk) configured globally,
something like this:

```ruby
AWS.config(
  :access_key_id     => AppConfig.aws.access_key,
  :secret_access_key => AppConfig.aws.secret_key
)
```

### API

The `S3Sign` module itself provides `.url`:

```ruby
# Pass a full s3 url and 1 hour expiration
S3Sign.url "http://s3.amazonaws.com/bucket/foo.png", 3600
# => "https://bucket.s3.amazonaws.com/foo.png?AWSAccessKeyId=access_key_id&Expires=1427243780&Signature=a3RzDgElxDpSZLgxurZLiw1a6Ny%3D"

# Pass a 'key' portion found under the bucket with default expiration
S3Sign.url "images/foo.png"
```

The gem also provides a `S3Sign::Helper` module, useful to mixin to rails
controllers.  It will add two helper methods to your controllers and views.

`s3_signed_url_for_key` - Takes a key/url and optional expires

`stable_s3_signed_url` - Takes a url and optional reference time.  Used for
generating signatures that expire in the far future year 2036.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/s3_sign/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
