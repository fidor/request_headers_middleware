# frozen_string_literal: true

require 'spec_helper'

describe RequestHeadersMiddleware::SidekiqExtensions::ServerMiddleware do
  describe '#call' do
    subject(:middleware) { described_class.new }

    context 'when request id present' do
      let(:message) do
        {
          'caller_request_headers' => {
            'X-Request-Id' => request_id
          }
        }
      end
      let(:request_id) { '7f4855c5-e3d7-4310-97cd-c611114e9dc7' }

      it 'set headers with same requiest id during job run' do
        middleware.call('MyWorker', message, 'queue') do
          expect(RequestHeadersMiddleware.store).to eq(
            'X-Request-Id': request_id
          )
        end
        expect(RequestHeadersMiddleware.store).to be_empty
      end
    end

    context 'when request id abcent' do
      let(:message) { { 'caller_request_headers' => {} } }
      let(:generated_uuid) { '037cb95c-8996-40c3-b890-ee99367fc769' }

      before do
        allow(SecureRandom).to receive(:uuid).and_return(generated_uuid)
      end

      it 'sets request id using SecureRandom' do
        middleware.call('MyWorker', message, 'queue') do
          expect(RequestHeadersMiddleware.store).to eq(
            'X-Request-Id': generated_uuid
          )
        end
        expect(RequestHeadersMiddleware.store).to be_empty
      end
    end
  end
end
