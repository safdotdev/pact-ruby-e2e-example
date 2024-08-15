source "http://rubygems.org"

if ENV['X_PACT_DEVELOPMENT']
  gem "pact", path: '../pact-ruby'
  gem "pact-support", path: '../pact-support'
  gem "pact-mock_service", path: '../pact-mock_service'
else
  gem "pact-mock_service", git: 'https://github.com/safdotdev/pact-mock_service.git', branch: 'feat/pact_v3_matcher_format'
  gem "pact-support", git: 'https://github.com/safdotdev/pact-support.git', branch: 'feat/pact_v3_matcher_format'
  gem "pact", git: 'https://github.com/safdotdev/pact-ruby.git', branch: 'feat/pact_v3_matcher_format'
end

gem "pact_broker-client"
gem "rake", "~> 12"
gem "rspec", "~> 3"
gem "faraday", "~> 1.0", "< 3.0"
gem "pry-byebug", "~> 3"
