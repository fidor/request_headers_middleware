# frozen_string_literal: true

require 'spec_helper'
require 'active_support/tagged_logging'

describe RequestHeadersMiddleware::SidekiqExtensions::JobLogger do
  subject(:job_logger) { described_class.new }

  let(:io) { StringIO.new }
  let(:logger) { ActiveSupport::Logger.new(io) }
  let(:tagged_logger) { ActiveSupport::TaggedLogging.new(logger) }
  let(:pid) { '999999999' }
  let(:tid) { 'tid' }
  let(:request_id) { '7f4855c5-e3d7-4310-97cd-c611114e9dc7' }
  let(:item) do
    {
      'caller_request_headers' => {
        'X-Request-Id' => request_id
      }
    }
  end

  before do
    allow(Sidekiq).to receive(:logger).and_return(tagged_logger)
    allow(Process).to receive(:pid).and_return(pid)
    allow(Sidekiq::Logging).to receive(:tid).and_return(tid)
    allow(Process).to receive(:clock_gettime).and_return(26_690.0)
  end

  context 'when job successfully done' do
    it 'logs start and done' do
      job_logger.call(item, 'queue') { 'success' }
      io.rewind
      expect(io.to_a).to eq(
        [
          "[#{request_id}] [PID: #{pid}] [TID-#{tid}] start\n",
          "[#{request_id}] [PID: #{pid}] [TID-#{tid}] done: 0.0 sec\n"
        ]
      )
    end
  end

  context 'when job fails' do
    it 'logs start and fail' do
      expect { job_logger.call(item, 'queue') { raise 'test error' } }.to raise_error
      io.rewind
      expect(io.to_a).to eq(
        [
          "[#{request_id}] [PID: #{pid}] [TID-#{tid}] start\n",
          "[#{request_id}] [PID: #{pid}] [TID-#{tid}] fail: 0.0 sec\n"
        ]
      )
    end
  end
end
