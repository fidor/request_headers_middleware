require 'byebug'
require 'request_headers_middleware/railtie' if defined?(Rails)
require 'request_headers_middleware/middleware'

module RequestHeadersMiddleware
  extend self

  attr_accessor :blacklist, :whitelist, :callbacks
  @whitelist = [ 'x-request-id'.to_sym ]
  @blacklist = []
  @callbacks = []

  def store
    RequestStore[:headers]
  end

  def setup(config)
    @whitelist = config.whitelist.map{|key| key.downcase.to_sym } if config.whitelist
    @blacklist = config.blacklist.map{|key| key.downcase.to_sym } if config.blacklist
    @callbacks = config.callbacks if config.callbacks
  end
end
