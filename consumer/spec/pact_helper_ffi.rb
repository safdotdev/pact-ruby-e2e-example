# via pact ffi
require 'pact/consumer/rspec_ffi'
Pact.configuration.pact_dir = File.dirname(__FILE__) + "/pacts"
Pact.configure do |config|
  # config.rust_log_level = 4
  config.logger.level = Logger::DEBUG
  # config.logger = Logger.new($stdout)
end
Pact.service_consumer_ffi "Foo" do
  has_pact_with "Bar" do
    mock_service :bar_service do
      pact_specification_version "3"
      # port 4638
    end
  end
end

