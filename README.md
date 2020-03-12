# RequestHeaderMiddleware [![build status](https://travis-ci.org/MarcGrimme/request_headers_middleware.png?branch=master)](https://travis-ci.org/MarcGrimme/request_headers_middleware) [![Code Climate](https://codeclimate.com/github/MarcGrimme/request_headers_middleware.png)](https://codeclimate.com/github/MarcGrimme/request_headers_middleware)

If you decided to go the microservice approach and services are growing everywhere you will release challenges as soon as more 
service are interconnected and you need to figure out problems. 

For example how can you connect a request over multiple micro service hubs? Imagine services connected synchronous or asynchronously then the 
whole challenge grows.

For this issue the *X-Request-Id* HTTP header was introduced. In Rails the *ActionDispatch::RequestId* middleware helps create a unique ID
for each request if not already defined by the *X-Request-Id* header. Unfortunatelly if your service connects to another service the passing
over of this unique id is not in the scope of the *ActionDispatch::RequestId* middleware.

For that issue this middleware will help you to use the same 'X-Request-Id' for multiple requests to in the end help you figure out the 
request path also over multiple services. But it will not do the whole game. It will mainly just store the *X-Request-Id* header in a globally
available throughout the application (and not only in the controller when getting a request).

The middleware can be extended to store more information from the header. For example you might want to reuse a *Bearer* token or the 
*X-Forward* header or more. For this you can either introduce whitelists - to only filter the headers you want to store - or a blacklist
to definitely not forward specific headers.

Default is the whilelist. It is initialized with *X-Request-Id*.

## Installation

### Rails

So how does it work with Rails.

Add this line to your application's Gemfile:

``
gem 'request_headers_middleware'
``

And then execute:

``
$ bundle
``
    
Or install it yourself as:
 
``
$ gem install request_headers_middleware
``
       
That's it now you can access the request headers (all you filtered - by default just the *X-Request-Id*) through the

``
RequestHeadersMiddleware.store
``

### ActiveResource::Base

For example to make *ActiveResource::Base* reuse the headers use:

```ruby
class BaseResource < ActiveResource::Base
  def self.headers
    RequestHeadersMiddleware.store.merge(ActiveResource::Base.headers)
  end

  ..
end
```

### Faraday

In *Faraday* you can do it as follows:

```ruby
Faraday.new(
  url: host,
  headers: RequestHeadersMiddleware.store,
  ..
) 
```

Or you can use middleware:
```ruby
connection = Faraday.new 'http://example.com/api' do |conn|
  conn.use RequestHeadersMiddleware::FaradayMiddleware
end
```

### JsonApiClient

For a class extended from *JsonApiClient* it could work like this. Let's call the class *MyJsonApiClient*.

```ruby
MyJsonApiClient.with_headers(RequestHeadersMiddleware.store) do
  .. # Do the request by the MyJsonApiClient
end
```

Another option is to use it globally for any request by using middleware:

```ruby
connection do |conn|
  conn.use RequestHeadersMiddleware::FaradayMiddleware
end

```

### Whitelist

Per default the middleware applies a whitelist to only filter *X-Request-Id* header. Generally this is just as follows:

``
Rails.configuration.request_headers_middleware.whitelist = [ 'X-Request-Id' ]
``

As this is just a list it can be easily overwriten in an initilizer.

### Blacklist

The same holds for the blacklist but first you need to disable the whitelist by setting it to nil or empty as follows.

``
Rails.configuration.request_headers_middleware.whitelist = [ 'X-Request-Id'  ]
``

### Callbacks

TODO: when I remeber why I thought this might make sense.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/marcgrimme/request_headers_middleware/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
