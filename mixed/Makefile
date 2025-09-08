PACT_RUBY_V2_ENABLE=true
PACT_RUBY_V1_ENABLE=false

all: test verify

install:
	bundle install

verify:
	bundle exec rspec -t pact spec/pact/consumers/multi_spec.rb

test:
	bundle exec rspec -t pact spec/pact/providers/**/*_spec.rb 
