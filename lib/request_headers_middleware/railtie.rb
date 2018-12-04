# frozen_string_literal: true

module RequestHeadersMiddleware
  # The Railtie triggering a setup from RAILs to make it configurable
  class Railtie < ::Rails::Railtie
    config.request_headers_middleware = ::ActiveSupport::OrderedOptions.new
    config.request_headers_middleware.blacklist = []
    config.request_headers_middleware.callbacks = []

    initializer 'request_headers_middleware.insert_middleware' do
      config.app_middleware.insert_after ActionDispatch::RequestId,
                                         RequestHeadersMiddleware::Middleware
      config.after_initialize do
        RequestHeadersMiddleware.setup(config.request_headers_middleware)
      end

      if defined?(Sidekiq)
        ::Sidekiq::Logging.logger = ::Rails.logger

        ::Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.prepend(::RequestHeadersMiddleware::SidekiqExtensions::ServerMiddleware)
          end
        end

        ::Sidekiq.configure_client do |config|
          config.client_middleware do |chain|
            chain.prepend(::RequestHeadersMiddleware::SidekiqExtensions::ClientMiddleware)
          end
        end

        ::Sidekiq.options[:job_logger] = ::RequestHeadersMiddleware::SidekiqExtensions::JobLogger

        ::Sidekiq.error_handlers.delete_if do |item|
          item.instance_of?(::Sidekiq::ExceptionHandler::Logger)
        end
        ::Sidekiq.error_handlers.unshift(
          ::RequestHeadersMiddleware::SidekiqExtensions::ExceptionLogger.new
        )
      end
    end
  end
end
