require 'json'
class BarApp
  def call env
    status = 200
    headers = { 'content-type' => 'application/json' }
    body = {
      "company": "My Company",
      "factories": [
        {
          "location": "Sydney",
          "capacity": 5
        },
        {
          "location": "Sydney",
          "geographicCoords": "-0.145,1.4445",
          "capacity": 5,
        }
      ]
    }.to_json
    [status, headers, [body]]
  end
end
