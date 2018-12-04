# frozen_string_literal: true

module RequestHeadersMiddleware
  module SidekiqExtensions
    class JobLogger
      # rubocop:disable Lint/RescueException
      def call(item, _queue)
        start = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
        add_tags(item)

        log(item, 'start')
        yield
        log(item, "done: #{elapsed(start)} sec")
      rescue Exception
        log(item, "fail: #{elapsed(start)} sec")
        raise
      ensure
        clear_tags
      end
      # rubocop:enable Lint/RescueException

      private

      def fetch_request_id(item)
        headers = item[::RequestHeadersMiddleware::SidekiqExtensions::MESSAGE_KEY]
        headers[::RequestHeadersMiddleware::Middleware::REQUEST_ID_HEADER.to_s]
      end

      def add_tags(item)
        request_id = fetch_request_id(item)
        logger.push_tags(request_id, *tags) if tagged_logger?
      end

      def clear_tags
        logger.clear_tags! if tagged_logger?
      end

      def log(item, msg)
        if tagged_logger?
          logger.info(msg)
        else
          request_id = fetch_request_id(item)
          tags_message = ([request_id] + tags).map { |tag| "[#{tag}]" }.join(' ')
          logger.info("#{tags_message} #{msg}")
        end
      end

      def tagged_logger?
        logger.respond_to?(:tagged)
      end

      def tags
        ["PID: #{::Process.pid}", "TID-#{::Sidekiq::Logging.tid}", sidekiq_context].compact
      end

      def sidekiq_context
        context = ::Thread.current[:sidekiq_context]
        context.join(' ') if context&.any?
      end

      def elapsed(start)
        (::Process.clock_gettime(::Process::CLOCK_MONOTONIC) - start).round(3)
      end

      def logger
        ::Sidekiq.logger
      end
    end
  end
end
