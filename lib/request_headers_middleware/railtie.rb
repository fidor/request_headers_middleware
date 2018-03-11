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
    end
  end
end
