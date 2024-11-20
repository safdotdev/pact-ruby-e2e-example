require 'sinatra'
require 'json'
require 'open3'
require 'webrick'
require 'webrick/https'

set :port, 9090
set :bind, '0.0.0.0'

post '/' do
  request.body.rewind
  body = request.body.read
  payload = JSON.parse(body)

  puts "Received webhook"
  puts "#{payload}"
  puts "Pact URL: #{payload["pactUrl"]}"

  pact_url = payload["pactUrl"]
  pact_verification_status = payload["githubVerificationStatus"]
  if pact_verification_status == "pending" && pact_url
    puts "Triggering provider tests..."
    stdout, stderr, status = Open3.capture3("cd ../e2e/provider && PACT_URL=#{payload["pactUrl"]} PACT_PUBLISH_VERIFICATION_RESULTS=true bundle exec rake pact:verify:foobar")
    puts "provider-verification: tests pending"
    puts stdout
    if status.success?
      puts "provider-verification: tests passed"
      status 200
    else
      puts "provider-verification [error]: #{stderr}"
      puts "provider-verification: tests failed"
      status 500
    end
  elsif pact_verification_status == "success" 
    verificationResultUrl = payload["verificationResultUrl"]
    puts "pact verification success - verificationResultUrl: #{verificationResultUrl}"
    status 200
  elsif pact_verification_status == "failed" 
    verificationResultUrl = payload["verificationResultUrl"]
    puts "pact verification failed - verificationResultUrl: #{verificationResultUrl}"
    status 200
  end

end

puts "## CI Simulator ## \n Broker webhook is listening on port #{settings.port}..."

# Start the server with SSL
webrick_options = {
  Port: settings.port,
  # BindAddress: settings.bind,
  # SSLEnable: true,
  # SSLCertificate: OpenSSL::X509::Certificate.new(File.open("server.crt").read),
  # SSLPrivateKey: OpenSSL::PKey::RSA.new(File.open("server.key").read),
  # SSLCertName: [["CN", WEBrick::Utils::getservername]]
}

trap(:TERM) { puts 'Received SIGTERM, shutting down...'; exit! }
trap(:INT) { puts 'Received SIGINT, shutting down...'; exit! }

Rack::Handler::WEBrick.run Sinatra::Application, **webrick_options