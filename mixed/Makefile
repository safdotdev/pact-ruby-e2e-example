all: test verify

install:
	bundle install

verify:
	bundle exec rspec -t pact spec/pact/consumers/multi_spec.rb

test:
	bundle exec rspec -t pact --exclude-pattern spec/pact/providers/**/kafka_spec.rb --pattern spec/pact/providers/**/*client_spec.rb 
