require_relative '../bar_app'

# pact rust
Pact.configuration.reports_dir = './provider/reports'
Pact.configure do |config|
  # config.rust_log_level = 5
  # config.logger.level = Logger::DEBUG
  # config.logger = Logger.new($stdout)
end
Pact.service_provider_ffi 'Bar' do
  provider_base_url 'http://localhost:9292'
  app_version '1.2.3'
  publish_verification_results !!ENV['PUBLISH_VERIFICATIONS_RESULTS']
  honours_pact_with 'Foo' do
    pact_uri './consumer/spec/support/foo-bar.json'
  end
end
