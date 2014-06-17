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

  describe "#call" do
    it "bahaves like a Rack middleware" do
      get "/"
      last_response.status.should == 200
    end
  end
end
