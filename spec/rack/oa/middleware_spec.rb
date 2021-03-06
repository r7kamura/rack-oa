require "spec_helper"
require "securerandom"

describe Rack::Oa::Middleware do
  include Rack::Test::Methods

  let(:app) do
    app = Rack::Builder.new
    app.use Rack::Oa::Middleware, options
    app.run ->(env) do
      [
        200,
        {},
        ["dummy"],
      ]
    end
    app
  end

  let(:options) do
    {
      authorization_class: authorization_class,
      client_class: client_class,
      resource_owner_class: resource_owner_class,
    }
  end

  let(:authorization_class) do
    Class.new do
      def self.find_by(access_token: nil)
        new
      end

      def self.create(client: nil, resource_owner: nil, scopes: nil)
        new
      end

      def to_hash
        {
          application: nil,
          created_at: nil,
          note: nil,
          scopes: nil,
          token: nil,
          updated_at: nil,
        }
      end
    end
  end

  let(:client_class) do
    Class.new do
      def self.find_by(client_id: nil, client_secret: nil)
        new
      end
    end
  end

  let(:resource_owner_class) do
    Class.new do
      def self.find_by(username: nil, password: nil)
        new
      end
    end
  end

  # Alias
  let(:response) do
    last_response
  end

  subject do
    send(method, path, request_body, env)
    response.status
  end

  let(:params) do
    {}
  end

  let(:headers) do
    {}
  end

  let(:request_body) do
    %r<application/json> === headers["Content-Type"] ? params.to_json : params
  end

  let(:env) do
    headers.inject({}) do |result, (key, value)|
      if key == "Content-Type"
        result.merge(key.upcase.gsub("-", "_") => value)
      else
        result.merge("HTTP_" + key.upcase.gsub("-", "_") => value)
      end
    end
  end

  let(:access_token) do
    SecureRandom.hex(32)
  end

  shared_examples_for "invalid request error" do
    it "returns an invalid request error" do
      should == 401
      response.body.should be_json_as(
        error: "invalid_request",
        error_message: "Access token was not given",
      )
    end
  end

  describe "GET /oauth/token" do
    let(:method) do
      :get
    end

    let(:path) do
      "/oauth/token"
    end

    context "without access token" do
      include_examples "invalid request error"
    end

    context "with Authorization header with bearer access token" do
      before do
        headers["Authorization"] = "Bearer #{access_token}"
      end

      it "returns access token details" do
        should == 200
        response.body.should be_json_as(
          application: nil,
          created_at: nil,
          note: nil,
          scopes: nil,
          token: nil,
          updated_at: nil,
        )
      end
    end

    context "with access token parameter" do
      before do
        params[:access_token] = access_token
      end

      it "always takes access token via parameter" do
        should == 200
      end
    end
  end

  describe "POST /oauth/token" do
    before do
      headers["Content-Type"] = "application/json"
      params[:client_id] = SecureRandom.hex(32)
      params[:client_secret] = SecureRandom.hex(32)
      params[:scopes] = []
    end

    let(:method) do
      :post
    end

    let(:path) do
      "/oauth/token"
    end

    context "without client_id parameter" do
      before do
        params.delete(:client_id)
      end
      include_examples "invalid request error"
    end

    context "without client_secret parameter" do
      before do
        params.delete(:client_secret)
      end
      include_examples "invalid request error"
    end

    context "with valid condition" do
      it "creates a authorization" do
        should == 201
        response.body.should be_json_as(
          application: nil,
          created_at: nil,
          note: nil,
          scopes: nil,
          token: nil,
          updated_at: nil,
        )
      end
    end
  end
end
