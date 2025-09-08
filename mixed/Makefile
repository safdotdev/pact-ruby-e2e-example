PACT_RUBY_V2_ENABLE=true
PACT_RUBY_V1_ENABLE=false

all: test verify

install:
	PACT_RUBY_V2_ENABLE=$(PACT_RUBY_V2_ENABLE) PACT_RUBY_V1_ENABLE=$(PACT_RUBY_V1_ENABLE) bundle install

verify:
	PACT_RUBY_V2_ENABLE=$(PACT_RUBY_V2_ENABLE) PACT_RUBY_V1_ENABLE=$(PACT_RUBY_V1_ENABLE) bundle exec rspec -t pact spec/pact/consumers/multi_spec.rb

test:
	PACT_RUBY_V2_ENABLE=$(PACT_RUBY_V2_ENABLE) PACT_RUBY_V1_ENABLE=$(PACT_RUBY_V1_ENABLE) bundle exec rspec -t pact spec/pact/providers/**/*_spec.rb
