# frozen_string_literal: true

require 'spec_helper'

describe RequestHeadersMiddleware::SidekiqExtensions::ClientMiddleware do
  describe '#call' do
    subject(:middleware) { described_class.new }

    let(:message) { {} }
    let(:headers) { { some_key: 'some_value' } }

    before do
      RequestHeadersMiddleware.store = headers
    end

    after do
      RequestHeadersMiddleware.store = {}
    end

    it 'adds headers to job context' do
      middleware.call('MyWorker', message, 'queue', 'redis_pool') { 'result' }
      expect(message).to eq('caller_request_headers' => headers)
    end
  end
end
