ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Disable API key auth in all tests
ENV["API_KEY"] = nil

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors, with: :threads)
    fixtures :all
  end
end

module ApiTestHelper
  def json_headers
    { "Content-Type" => "application/json", "Accept" => "application/json" }
  end

  def json_body
    JSON.parse(response.body)
  end

  def post_json(path, params = {})
    post path, params: params.to_json, headers: json_headers
  end

  def put_json(path, params = {})
    put path, params: params.to_json, headers: json_headers
  end
end
