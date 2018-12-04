# frozen_string_literal: true

# Notice there is a .rspec file in the root folder. It defines rspec arguments

# Ruby 1.9 uses simplecov. The ENV['COVERAGE'] is set when rake coverage
# is run in ruby 1.9
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    # Remove the spec folder from coverage. By default all code files are
    # included.
    # For more config options see
    # https://github.com/colszowka/simplecov
    add_filter File.expand_path('../spec', __dir__)
  end
end

# Modify load path so you can require 'ogstasher directly.
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'rubygems'
# Loads bundler setup tasks. Now if I run spec without installing gems then it
# would say gem not installed and do bundle install instead of ugly load error
# on require.
require 'bundler/setup'

# This will require me all the gems automatically for the groups. If I do only
# .setup then I will have to require gems manually. Note that you have still
# have to require some gems if they are part of bigger gem like ActiveRecord
# which is part of Rails. You can say :require => false in gemfile to always
# use explicit requiring
Bundler.require(:test)

require 'sidekiq'
Dir[File.join('./spec/support/**/*.rb')].each { |f| require f }

# Set Rails environment as test
ENV['RAILS_ENV'] = 'test'

require 'request_headers_middleware'
require 'rack/mock'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
