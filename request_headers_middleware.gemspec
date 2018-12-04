# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_headers_middleware/version'

Gem::Specification.new do |gem|
  gem.name          = 'request_headers_middleware'
  gem.version       = RequestHeadersMiddleware::VERSION
  gem.authors       = ['Marc Grimme']
  gem.email         = ['marc.grimme@gmail.com']
  gem.description   = 'RequestHeader gives you per-req global header storage.'
  gem.summary       = 'RequestStore gives you per-reqt global header storage.'
  gem.homepage      = 'http://github.com/fidor/request_headers_middleware'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'request_store', '~> 1.4', '>= 1.4.0'
  gem.add_development_dependency 'activesupport', '~> 4.0'
  gem.add_development_dependency 'rack', '~> 1.6', '>= 1.6.5'
  gem.add_development_dependency 'rake', '~> 12.0', '>= 12.0.0'
  gem.add_development_dependency 'rspec', '~> 3.5', '>= 3.5.0'
  gem.add_development_dependency 'rubocop', '~> 0.60.0'
  gem.add_development_dependency 'sidekiq', '~> 5.0'
  gem.add_development_dependency 'simplecov', '~> 0.12.0'
end
