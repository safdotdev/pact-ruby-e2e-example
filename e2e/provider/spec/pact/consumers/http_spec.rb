# frozen_string_literal: true

require 'sbmt/pact/rspec'
require_relative '../../../bar_app'

RSpec.describe 'Verify consumers for Bar Provider', :pact do
  http_pact_provider 'Bar'
  puts pact_config.inspect
  pact_config.instance_variable_set(:@app, BarApp.new)
  pact_config.instance_variable_set(:@http_port, 9292)

end
