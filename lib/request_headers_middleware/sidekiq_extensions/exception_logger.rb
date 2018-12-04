# frozen_string_literal: true

module RequestHeadersMiddleware
  module SidekiqExtensions
    class ExceptionLogger
      def call(exception, context_hash)
        if ::Sidekiq.logger.respond_to?(:tagged)
          request_id = fetch_request_id(context_hash)
          ::Sidekiq.logger.tagged(request_id) { log_exception(exception, context_hash) }
        else
          log_exception(exception, context_hash)
        end
      end

      private

      def fetch_request_id(context_hash)
        job_hash = context_hash[:job]
        passed_headers = job_hash[::RequestHeadersMiddleware::SidekiqExtensions::MESSAGE_KEY]
        passed_headers[::RequestHeadersMiddleware::Middleware::REQUEST_ID_HEADER.to_s]
      end

      def log_exception(exception, context_hash)
        log_context(context_hash)
        log_error(exception)
      end

      def log_context(context_hash)
        ::Sidekiq.logger.warn(::Sidekiq.dump_json(context_hash)) unless context_hash.empty?
      end

      def log_error(exception)
        ::Sidekiq.logger.warn("#{exception.class.name}: #{exception.message}")
        ::Sidekiq.logger.warn(exception.backtrace.join("\n")) unless exception.backtrace.nil?
      end
    end
  end
end
