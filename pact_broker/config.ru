require 'logger'
require 'sequel'
require 'pact_broker'
# require "pact_broker/configuration"

# puts PactBroker.configuration.port
DATABASE_CREDENTIALS = {adapter: "sqlite", database: "pact_broker_database.sqlite3", :encoding => 'utf8'}

#  run via one of the following:
#  
#  $ bundle exec rackup -s thin
#  $ bundle exec rackup -s puma
#  $ bundle exec rackup -s webrick
#  
#  Note: if using thin, publishing results will fail with the rust verifier, as it requires the Accept-Charset header
#  to be set to utf-8. Use puma or webrick instead, until change proposed/merged in pact-rust

ENV['PACT_BROKER_WEBHOOK_SCHEME_WHITELIST'] = 'http'
ENV['PACT_BROKER_WEBHOOK_HOST_WHITELIST'] = 'localhost'
# ENV['PACT_BROKER_DISABLE_SSL_VERIFICATION'] = 'true'
# ENV['PACT_BROKER_BASE_URL'] = 'http://localhost:9292"'
# ENV['PACT_BROKER_BASE_URLS'] = 'http://localhost:9292 http://127.0.0.1:9292 http://0.0.0.0:9292'

app = PactBroker::App.new do | config |
  config.log_stream = "stdout"
  config.database_connection = Sequel.connect(DATABASE_CREDENTIALS.merge(:logger => config.logger))
  # the below values dont appear to take effect when calling webhooks
  # lib/pact_broker/api/contracts/webhook_request_contract.rbL75
  # allowed_webhook_scheme?

  # config.base_url = "http://localhost:9292"
  # config.base_urls = "http://localhost:9292 http://127.0.0.1:9292 http://0.0.0.0:9292"
  # config.webhook_scheme_whitelist = "http"
  # config.webhook_host_whitelist = "localhost"
  # config.disable_ssl_verification = "true"
  # config.database_url = "sqlite:////tmp/pact_broker_database.sqlite3"
end

run app
