# frozen_string_literal: true
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_headers_middleware/version'

Gem::Specification.new do |gem|
  gem.name          = 'request_headers_middleware'
  gem.version       = RequestHeadersMiddleware::VERSION
  gem.authors       = ['Marc Grimme']
  gem.email         = ['marc.grimme@gmail.com']
  gem.description   = 'RequestHeader gives you per-req global header storage.'
  gem.summary       = 'RequestStore gives you per-reqt global header storage.'
  gem.homepage      = 'http://github.com/marcgrimme/request_headers_middleware'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'request_store'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rack'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'rubocop'
end
