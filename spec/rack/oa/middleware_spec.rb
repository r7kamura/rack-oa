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

  describe "POST /token" do
    let(:method) do
      :post
    end

    let(:path) do
      "/token"
    end

    it { should == 200 }
  end
end
