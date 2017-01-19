require 'spec_helper'

describe RequestHeadersMiddleware::Middleware do

  let(:app) { MockRackApp.new }
  subject { described_class.new(app) }

  context "when called with a POST request" do
    let(:env) { Rack::MockRequest.env_for('/some/path', {'HTTP_X_REQUEST_ID' => '1234', 'CONTENT_TYPE' => 'text/plain'}) }

    it "passes the request through unchanged" do
      subject.call(env)
      expect(app['CONTENT_TYPE']).to eq('text/plain')
    end
  end
end
