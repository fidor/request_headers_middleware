# frozen_string_literal: true

module RequestHeadersMiddleware # :nodoc:
  extend self

  attr_accessor :blacklist, :whitelist, :callbacks
  @whitelist = ['x-request-id'.to_sym]
  @blacklist = []
  @callbacks = []

  def store
    RequestStore[:headers] ||= {}
  end

  def store=(store)
    RequestStore[:headers] = store
  end

  def setup(config)
    @whitelist = config.whitelist.map { |key| key.downcase.to_sym } if config.whitelist
    @blacklist = config.blacklist.map { |key| key.downcase.to_sym } if config.blacklist

    config.callbacks && @callbacks = config.callbacks
  end
end

require 'request_headers_middleware/middleware'
require 'request_headers_middleware/sidekiq_extensions' if defined?(Sidekiq)
require 'request_headers_middleware/railtie' if defined?(Rails)
