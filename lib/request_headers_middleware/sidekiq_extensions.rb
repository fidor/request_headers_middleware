# frozen_string_literal: true

module RequestHeadersMiddleware
  module SidekiqExtensions
    MESSAGE_KEY = 'caller_request_headers'
  end
end

require_relative './sidekiq_extensions/client_middleware'
require_relative './sidekiq_extensions/server_middleware'
require_relative './sidekiq_extensions/job_logger'
require_relative './sidekiq_extensions/exception_logger'
