# frozen_string_literal: true

require 'spec_helper'
require 'active_support/tagged_logging'

describe RequestHeadersMiddleware::SidekiqExtensions::ExceptionLogger do
  subject(:exception_logger) { described_class.new }

  let(:io) { StringIO.new }
  let(:logger) { ActiveSupport::Logger.new(io) }
  let(:tagged_logger) { ActiveSupport::TaggedLogging.new(logger) }
  let(:request_id) { '7f4855c5-e3d7-4310-97cd-c611114e9dc7' }
  let(:context) do
    {
      context: 'job_context',
      job: {
        'caller_request_headers' => {
          'X-Request-Id' => request_id
        }
      }
    }
  end
  let(:exception) { StandardError.new('message') }

  before do
    allow(Sidekiq).to receive(:logger).and_return(tagged_logger)
  end

  it 'logs context with error' do
    exception_logger.call(exception, context)
    io.rewind
    expect(io.to_a).to eq(
      [
        "[#{request_id}] {\"context\":\"job_context\","\
        '"job":{"caller_request_headers":'\
        "{\"X-Request-Id\":\"#{request_id}\"}}}\n",
        "[#{request_id}] StandardError: message\n"
      ]
    )
  end
end
