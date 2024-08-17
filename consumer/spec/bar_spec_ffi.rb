require 'faraday'
require 'pact/consumer/rspec_ffi'
require_relative 'pact_helper_ffi'

describe "BarClient", :pact => true do
  it "can retrieve a thing"  do
    bar_service.
      upon_receiving("a retrieve thing request").with({
      method: :get,
      path: '/thing',
      headers: {'Accept' => 'application/json'}
    }).
      will_respond_with({
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        company: Pact.like("My big company"),
        factories: Pact.each_like(location: "Sydney", capacity: 5)
      }
    })

    puts bar_service.start_mock
    puts bar_service.mock_service_base_url
    # This request would normally be performed some BarClient class,
    # but just use simple request for the purposes of this test
    bar_response = Faraday.get(bar_service.mock_service_base_url + "/thing", nil, {'Accept' => 'application/json'})

    # This would normally be checking the results of some deserialisation process,
    # (eg. check for an array of Factory classes )
    # but just check the response code for the purposes of this test
    expect(bar_response.status).to eql 200
    expect(JSON.parse(bar_response.body)).to eq JSON.parse('{"company":"My big company","factories":[{"location":"Sydney","capacity":5}]}')
  end
end