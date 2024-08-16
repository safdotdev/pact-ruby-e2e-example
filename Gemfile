source "http://rubygems.org"

if ENV['X_PACT_DEVELOPMENT']
  gem "pact", path: '../pact-ruby'
  gem "pact-support", path: '../pact-support'
  gem "pact-mock_service", path: '../pact-mock_service'
  gem "pact-ffi", path: '../pact-ruby-ffi'
  gem "pact_broker-client", path: '../pact_broker-client'
else
  gem "pact", "~> 1.63", git: 'https://github.com/safdotdev/pact-ruby.git', branch: 'feat/ffi_namespace'
  gem 'pact-support', '~> 1.16', '>= 1.16.9', git: 'https://github.com/safdotdev/pact-support.git', branch: 'feat/ffi'
  # gem "pact-ffi", "~> 0.4", git: 'https://github.com/safdotdev/pact-ruby-ffi.git', branch: 'feat/ffi'
  gem "pact_broker-client"
end

gem "rake", "~> 13"
gem "rspec", "~> 3"
gem "faraday", "~> 1.0", "< 3.0"
gem "pry-byebug", "~> 3"
# gem 'rack-reverse-proxy'
# gem 'rack-reverse-proxy', :git => 'https://github.com/samedi/rack-reverse-proxy.git', branch: 'main'
gem "rackup", "~> 2.1"
