# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

describe RequestHeadersMiddleware::FaradayAdapter do
  context 'when MockRackApp called with a request' do
    let(:app) { MockRackApp.new }
    let(:env) do
      Rack::MockRequest.env_for('/example')
    end
    subject { described_class.new(app) }

    it 'merges current headers with RequestHeadersMiddleware.store' do
      allow(RequestHeadersMiddleware).to receive(:store).and_return('X-Request-Id': '1234')
      env[:request_headers] = { 'X-Test': '4321' }

      subject.call(env)
      expect(env[:request_headers]).to eq('X-Test': '4321', 'X-Request-Id': '1234')
    end
  end

  context 'adapter is used as faraday middleware ' do
    before do
      stub_request(:get, /example.com/)

      Faraday.default_connection = Faraday.new do |conn|
        conn.request :url_encoded
        conn.use RequestHeadersMiddleware::FaradayAdapter
        conn.adapter Faraday.default_adapter
      end
    end

    it 'merges current headers with RequestHeadersMiddleware.store' do
      expect_any_instance_of(RequestHeadersMiddleware::FaradayAdapter).to receive(:call)

      Faraday.get('http://example.com')
    end
  end
end
