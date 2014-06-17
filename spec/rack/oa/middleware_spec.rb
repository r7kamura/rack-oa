require "spec_helper"
require "securerandom"

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

  let(:headers) do
    {}
  end

  let(:env) do
    headers.inject({}) do |result, (key, value)|
      result.merge("HTTP_" + key.upcase.gsub("-", "_") => value)
    end
  end

  let(:access_token) do
    SecureRandom.hex(32)
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

    context "with Authorization header with bearer access token" do
      before do
        headers["Authorization"] = "Bearer #{access_token}"
      end
      it { should == 200 }
    end

    context "with access token parameter" do
      before do
        params[:access_token] = access_token
      end
      it { should == 200 }
    end
  end
end
