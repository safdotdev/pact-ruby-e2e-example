require_relative '../bar_app'
# require 'rack/reverse_proxy'

Pact.configuration.reports_dir = './provider/reports'
Pact.configure do |config|
  # config.rust_log_level = 5
  # config.logger.level = Logger::DEBUG
  # config.logger = Logger.new($stdout)
end
Pact.service_provider 'Bar' do
  # app { BarApp.new }
  # app do
  #   Rack::ReverseProxy.new do
  #     reverse_proxy '/', 'http://localhost:9292'
  #   end
  # end
  provider_base_url 'http://localhost:9292'
  app_version '1.2.3'
  publish_verification_results !!ENV['PUBLISH_VERIFICATIONS_RESULTS']

  honours_pact_with 'Foo' do
    # provider_base_url 'http://localhost:9292'
    pact_uri './consumer/spec/support/foo-bar.json'
  end
end
