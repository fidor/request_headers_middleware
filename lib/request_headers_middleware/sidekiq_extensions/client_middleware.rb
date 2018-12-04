# frozen_string_literal: true

module RequestHeadersMiddleware
  module SidekiqExtensions
    class ClientMiddleware
      def call(_worker_class, msg, _queue, _redis_pool)
        msg[
          ::RequestHeadersMiddleware::SidekiqExtensions::MESSAGE_KEY
        ] = ::RequestHeadersMiddleware.store
        result = yield
        result
      end
    end
  end
end
