require 'request_store'

module RequestHeadersMiddleware
  class Middleware
    def initialize(app)
      @app = app
    end
    
    def call(env)
      RequestStore.store[:headers] = filter(headers(env))
      RequestHeadersMiddleware.callbacks.each { |cb| cb.call(env) } if RequestHeadersMiddleware.callbacks
      @app.call(env)
    end

    private
    def headers(env)
      default_headers(env).merge(Hash[*sanitize_headers(select_headers(env)).sort.flatten])
    end

    def filter(headers)
      if RequestHeadersMiddleware.whitelist && ! RequestHeadersMiddleware.whitelist.empty?
        whitelist(headers)
      else
        blacklist(headers)
      end
    end

    def select_headers(env)
      env.select {|k,v| k.start_with? 'HTTP_'}
    end

    def sanitize_headers(headers)
      headers.collect {|k,v| [k.sub(/^HTTP_/, ''), v]}
        .collect {|k,v| [k.split('_').collect(&:capitalize).join('-').to_sym, v]}
    end

    def whitelist(headers)
      headers.select{ |key, _| RequestHeadersMiddleware.whitelist.include?(key.downcase) }
    end

    def blacklist(headers)
      headers.reject{ |key, _| RequestHeadersMiddleware.blacklist.include?(key.downcase) }
    end

    def default_headers(env)
      { :"X-Request-Id" => env["action_dispatch.request_id"] }
    end
  end
end
