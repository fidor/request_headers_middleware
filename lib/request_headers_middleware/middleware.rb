# frozen_string_literal: true

require 'request_store'

module RequestHeadersMiddleware # :nodoc:
  # The Middleware that stores the header. Default is only to store the
  # X-Request-Id or the action_dispatch.request_id from environment if not set.
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      RequestStore.store[:headers] = filter(headers(env))
      RequestHeadersMiddleware.callbacks.each { |cb| cb.call(env) }
      @app.call(env)
    end

    private

    def headers(env)
      default_headers(env)
        .merge(Hash[*sanitize_headers(select_headers(env)).sort.flatten])
    end

    def filter(headers)
      if RequestHeadersMiddleware.whitelist &&
         !RequestHeadersMiddleware.whitelist.empty?
        whitelist(headers)
      else
        blacklist(headers)
      end
    end

    def select_headers(env)
      env.select { |k, _v| k.start_with? 'HTTP_' }
    end

    def sanitize_headers(headers)
      headers.collect { |k, v| [k.sub(/^HTTP_/, ''), v] }.collect do |k, v|
        [k.split('_').collect(&:capitalize).join('-').to_sym, v]
      end
    end

    def whitelist(headers)
      headers.select do |key, _|
        RequestHeadersMiddleware.whitelist.include?(key.downcase)
      end
    end

    def blacklist(headers)
      headers.reject do |key, _|
        RequestHeadersMiddleware.blacklist.include?(key.downcase)
      end
    end

    def default_headers(env)
      { "X-Request-Id": env['action_dispatch.request_id'] }
    end
  end
end
