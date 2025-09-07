# frozen_string_literal: true

require "sbmt/pact/rspec"

RSpec.describe "Sbmt::Pact::Consumers::Http", :pact do
  mixed_pact_provider "sbmt-pact-test-app", opts: {
    http: {
      http_port: 3000,
      log_level: :info
    },
    grpc: {
      grpc_port: 3009
    }
  }
  
end
