require "spec_helper"

describe Rack::Oa::Middleware do
  include Rack::Test::Methods

  let(:app) do
    Rack::Builder.app do
      use Rack::Oa::Middleware
      run ->(env) do
        [
          200,
          {},
          ["dummy"],
        ]
      end
    end
  end

  # Alias
  let(:response) do
    last_response
  end

  subject do
    send(method, path, params, env)
    response.status
  end

  let(:params) do
    {}
  end

  let(:env) do
    {}
  end

  describe "GET /oauth/token" do
    let(:method) do
      :get
    end

    let(:path) do
      "/oauth/token"
    end

    context "without access token" do
      it { should == 401 }
    end
  end
end
