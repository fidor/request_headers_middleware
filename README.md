# RequestHeaderMiddleware [![build status](https://travis-ci.org/marcgrimme/request_headers_middleware.png?branch=master)](https://travis-ci.org/marcgrimme/request_headers_middleware) [![Code Climate](https://codeclimate.com/github/marcgrimme/request_headers_middleware.png)](https://codeclimate.com/github/marcgrimme/request_headers_middleware)

If you decided to go the microservice approach and services are growing everywhere you will release challenges as soon as more 
service are interconnected and you need to figure out problems. Cause how can you connect a request over multiple micro service
hubs? Imaging service connected synchronous or asynchronously.

For this issue the 'X-Request-Id' HTTP header was invented. This middleware will help you to use the same 'X-Request-Id' for multiple requests
to help you figure out the request path.

## Installation

### Rails

So how does it work with Rails.

Add this line to your application's Gemfile:

``ruby
gem 'logger_instrumentation'
``

And then execute:

  $ bundle
    
Or install it yourself as:
 
  $ gem install request_headers_middleware
       
That's it now you can access the request_headers (all of them) through the

``ruby
RequestHeadersMiddleware.store
``

For example to make *ActiveResource::Base* reuse the headers use:

``ruby
class BaseResource < ActiveResource::Base
  def self.headers
    ActiveResource::Base.headers.merge(RequestHeadersMiddleware.store)
  end

  ..
end
``

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/marcgrimme/request_headers_middleware/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
