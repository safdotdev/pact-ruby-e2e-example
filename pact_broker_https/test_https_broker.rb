#!/usr/bin/env ruby

# This script is for testing SSL connection issues where a self signed certificate is used.
# The default values allow it to connect to the server started by `bundle exec ruby spec/support/ssl_webhook_server.rb`

require "bundler/inline"

gemfile(true, quiet: ENV.fetch("BUNDLER_INLINE_QUIET_INSTALL", "true") == "true") do
  source "https://rubygems.org"

  gem "openssl"
  gem "stringio"
end

# Allow cancelling without error
Signal.trap("SIGINT") do
  # Reset terminal output if the script quits while installing gems using the quiet option
  system "stty echo"
  # Force outputting a newline
  puts ""
  # Revert any pending operation…
  # Indicate that the script terminated gracefully
  exit true
end

require "net/http"
require "openssl"

TEST_URL = "https://localhost:4444"
TEST_CERTIFICATE = "-----BEGIN CERTIFICATE-----
MIIDZDCCAkygAwIBAgIBATANBgkqhkiG9w0BAQsFADBCMRMwEQYKCZImiZPyLGQB
GRYDb3JnMRkwFwYKCZImiZPyLGQBGRYJcnVieS1sYW5nMRAwDgYDVQQDDAdSdWJ5
IENBMCAXDTE4MDUxNzA3NDQzNVoYDzIxMTgwNDIzMDc0NDM1WjBCMRMwEQYKCZIm
iZPyLGQBGRYDb3JnMRkwFwYKCZImiZPyLGQBGRYJcnVieS1sYW5nMRAwDgYDVQQD
DAdSdWJ5IENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1tcEnh7S
iiL46HNfx5LkGxBZ9Dn7tUm6CKlPzykjlCGZ9a5VpnZxwEK5LkIvbMiBz8UjhcVh
8pUghbyvwSHdtiMDNU4zpKIgrTXZ/tiqctgYYSFbtEtE17VrVM8JZFSxzLSJEvEZ
rhkOqeVEGJJY28taItbjxfHYkTlQYTjn6tA18KT13nGAUMEoC0HZTHYr2nCY7MzI
cEISvm5PP7gXKHrOfpbm+E3qMm9kyDQLkez8iGfq2aGSshuT4mcAvxq5dS6TsPSy
ZphnfHw3THqgBrR8Bw1tMhsnLhD96Miy5sRnY2gQEAQngccLZ/F6ls6a+5Adka2o
zFmJVZXhHbVeRwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQE
AwIBBjAdBgNVHQ4EFgQUBX8ZMupoE2NMwyE1kdlVptFti/kwHwYDVR0jBBgwFoAU
BX8ZMupoE2NMwyE1kdlVptFti/kwDQYJKoZIhvcNAQELBQADggEBAIxS0jDTRC9R
mxsr2j/o9oQvRi5+74qDlXs7YzbQ1V7dy++g48St6Yjk4xfdGdgAS8IrS9vIRKUy
jnlwUklnkvoWk2DKF9NFA32c1mxZhau5QGu3VH7pgmcWQawXttqpgHbSLEDAf9wU
jgTRdL8LxMIf6xy2uPL8GZWFbmdU5HOb3czS1drouE0U3ZI+1uzAlR3vqGo0Mvhd
MwYBodIJlWa0mXKMnfZxYLtiv7m5H5I2zBfget3+3ovuN79Zn6RA3ecnxn75jalA
R6MNlS/tzpXcS/gwnSKrwHSjb1V+B4Q96EsfulWC2UpTa0WTxngyiqtp6GU6RZva
jHT1Ty2CglM=
-----END CERTIFICATE-----
"

SSL_CERT = ENV.key?("PACT_SSL_CACERT_FILE") ? File.read(ENV["PACT_SSL_CACERT_FILE"]) : TEST_CERTIFICATE

def split_certificate_chain(content)
  content.split(/(-----END [^\-]+-----)/).each_slice(2).map(&:join).map(&:strip).select{|s| !s.empty?}
end

def build_cert_store
  cert_store = OpenSSL::X509::Store.new
  split_certificate_chain(SSL_CERT).each do | content |
    cert_store.add_cert(OpenSSL::X509::Certificate.new(content))
  end
  cert_store
end

uri = URI.parse(TEST_URL)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.cert_store = build_cert_store
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
data = http.get(uri.request_uri)
puts data.body
