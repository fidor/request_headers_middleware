require 'byebug'
require 'request_headers_middleware/railtie' if defined?(Rails)
require 'request_headers_middleware/middleware'

module RequestHeadersMiddleware
  extend self

  attr_accessor :blacklist, :callbacks

  def store
    RequestStore[:headers]
  end

  def setup(config)
    @blacklist = config.blacklist
    @callbacks = config.callbacks
  end
end
