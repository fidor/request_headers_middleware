# frozen_string_literal: true

require 'faraday_middleware'

module RequestHeadersMiddleware
  class FaradayAdapter < Faraday::Middleware
    def call(env)
      env[:request_headers].merge! RequestHeadersMiddleware.store

      @app.call(env)
    end
  end
end
