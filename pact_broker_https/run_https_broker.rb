#!/usr/bin/env ruby
if __FILE__ == $0
  
  require "bundler/inline"
gemfile(true, quiet: ENV.fetch("BUNDLER_INLINE_QUIET_INSTALL", "true") == "true") do
  source "https://rubygems.org"

  if ENV["X_PACT_DEVELOPMENT"] == "true"
    gem "pact_broker", path: "../../pact_broker"
  else
    gem "pact_broker", git: 'https://github.com/YOU54F/pact_broker.git', branch: 'feat/secrets-2'
  end
  gem "sqlite3"

  # std gem deprecations
  gem "csv"
  gem "mutex_m"
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

TEST_SSL_KEY = "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAkUsljRAccTCnUibnKE+G967PMavfE1Vdy6O0ci2W3/ylJe0N
xrbXX5y0QUW+PawDHFyzgKXHHQVau5CJjUD2TgYZQ/N/bMabqWEYkO3oVXLGZBlT
MNd4C99Uh3GnmCFcRXADCYgQkrrKpNqeSqXIKIoc5zl+jJGFdbNk0QEW36G0swN5
hnMwNH6yXv3SecWcpgYaUN3BVKJza5y3gS9qT9oygMkCy2Fvgn4/lNughCmUgK3v
2OcXEjj9ACFbJ0I1BmGLGzzNT6JAPJ/wmKXqaUHci/p0HDntnLBwIgWvZEnYjNRr
IXb5zjtVKB0PRnMje14pJgcN+Cbwe1VL4pWniQIDAQABAoIBAHskPqJNKl4Ax39I
O5idtp2Lyk2mBr5DFuj2SYSQARS781iujoOCCg4eKWQ88R0iAczzAKwjVRvSovDf
csWGbnr4jkdaRAB0YA/xnDmRed2aFm1WTXzS0gr18JWPDWVRuPudEOXuLWW+7OtF
4u0PjxJU5GRRBWGsIHn+Xo8JplJIW4vWSrwEp8G+rJqzQ6hUN8kHS8Sz3tLy3puQ
fu9o4CTiZMDIlRu0PqzBIJ8wuSUa9McSQzdvr3sQGmx0bpmuXbslEuZWjQPGdN2M
FMHCelRPBOJr1w/kP/pcORSWv4K3wUtKDS4/zzgaq2dmXOVAgGWyC04VGKgZ0XL/
WyiYAYECgYEAwapB4V9wEEbBXMBEzg6KEX2mCPsGqCMuwGfh2+erw4vAebjX5pBQ
AQ9Ip7Nvk+9X+ns4gOxvtPAEBAXNkU7cvFvdJaQ023QMATDj1s/a7rNbXHql3CYy
vBmsKQFm/eF3oi8NXRnyqsh1j8wWLpXDwp8wVAtPP1Rfx3SzJEd2czkCgYEAwA8j
6ILlxsSj59px9Lo/a0ug0GtXoNjX1p7pCCZFK8P0guu/JC8we/tQob8nStpGJ/Jo
+WO4sQUyKwqezo9FqLO41NFvySQ2HbIs40Hpv0CWzX17zJA5zwWbuAb9oGaWAICP
JHIPbOlYc18y56kbMzQh/gMdNVC819Ku3YJgRtECgYBwv/npB1JL95WdtUaZnLdf
ZYKj2dnPS+RtGk3RZHiIuTVO6IGx9zTM2SQYlowQWZkj+Fc2H/ENK2t7GBHNVleG
xgjjYE1xsodGrjsHli3FKOC436Lun8KL5npnySw4BOtMng4utOul6F0hYdVMO98j
0OAnHgp+OVYl3lhpd72LaQKBgC/kFpol+dIEurJX4E6cGrBQnXsbKTCsobWczpL/
qAPvywrSaklFkxt3YXXTyqJ5p0DSy6ZUXXuWxhnBfjQXudEFb7NxviQz6WKiSVsp
1nWgT3pSLgqmdCPRTDEpXRkgO4tIg2kdIAeScEHknTbzDhtIhqlmcWQYC97tZDlM
B2HhAoGAXKZrKbiQlQ+AdMoFHFDdViQc+yotF03HNryJHMqXHWgL67wJNhsZymlU
1nfU74llxLj+w6Fx2h8UOTf5HFSx+6YUuLYM02PW398oi0NmqhuXvdTs4qk/tbf6
7/P2Ddgcr2M4iB0LbIude4JKMby3gDiY1RzpGJpvRyYhDyr+owk=
-----END RSA PRIVATE KEY-----
"

TEST_SSL_CERT="-----BEGIN CERTIFICATE-----
MIIDNDCCAhygAwIBAgIBAjANBgkqhkiG9w0BAQsFADBCMRMwEQYKCZImiZPyLGQB
GRYDb3JnMRkwFwYKCZImiZPyLGQBGRYJcnVieS1sYW5nMRAwDgYDVQQDDAdSdWJ5
IENBMCAXDTE4MDUxNzA3NDQzNVoYDzIxMTgwNDIzMDc0NDM1WjBEMRMwEQYKCZIm
iZPyLGQBGRYDb3JnMRkwFwYKCZImiZPyLGQBGRYJcnVieS1sYW5nMRIwEAYDVQQD
DAlsb2NhbGhvc3QwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCRSyWN
EBxxMKdSJucoT4b3rs8xq98TVV3Lo7RyLZbf/KUl7Q3GttdfnLRBRb49rAMcXLOA
pccdBVq7kImNQPZOBhlD839sxpupYRiQ7ehVcsZkGVMw13gL31SHcaeYIVxFcAMJ
iBCSusqk2p5KpcgoihznOX6MkYV1s2TRARbfobSzA3mGczA0frJe/dJ5xZymBhpQ
3cFUonNrnLeBL2pP2jKAyQLLYW+Cfj+U26CEKZSAre/Y5xcSOP0AIVsnQjUGYYsb
PM1PokA8n/CYpeppQdyL+nQcOe2csHAiBa9kSdiM1GshdvnOO1UoHQ9GcyN7Xikm
Bw34JvB7VUvilaeJAgMBAAGjMTAvMA4GA1UdDwEB/wQEAwIHgDAdBgNVHQ4EFgQU
qVjAGwu3nbFw5OJDPEmJ/lO24gQwDQYJKoZIhvcNAQELBQADggEBAMK3j313EZxR
msAdmlVKKldRQGTXpu59wune60cME/BWYrPlprmIREy8ygJl1hqLivoQpxyWfJw3
RxTNSg6b1JYDq1ze3OxqcWMVPOC2rAwOAa57eQxS4fB9RLL18PuLzcHPRnNBbphl
NfB47ymIdMwH2WuuSg2qY0E35ufX09dK6sV+LdgzKsYDQFgYTzBoWen+WGCvNZ/i
dzCv7ZhZwVhDm8CoBoc6eHamzFmt4ysdZ95FarMHGTllAVrqLMwu6IIoIEj4C07X
n7E5lMFJkOPlA9UJFHHzOqEb3jk/fIe/QPuyXQDLxOY+tLCBRw32lO+3jzpgLrJ2
YbVnmeUvpz0=
-----END CERTIFICATE-----
"

SSL_KEY = ENV.key?("PACT_SSL_KEY_FILE") ? File.read(ENV["PACT_SSL_KEY_FILE"]) : TEST_SSL_KEY
SSL_CERT = ENV.key?("PACT_SSL_CERT_FILE") ? File.read(ENV["PACT_SSL_CERT_FILE"]) : TEST_SSL_CERT

  trap(:INT) do
    @server.shutdown
    exit
  end

  def webrick_opts port
    certificate = OpenSSL::X509::Certificate.new(SSL_CERT)
    cert_name = certificate.subject.to_a.collect{|a| a[0..1] }
    {
      Port: port,
      Host: "0.0.0.0",
      AccessLog: [],
      SSLCertificate: certificate,
      SSLPrivateKey: OpenSSL::PKey::RSA.new(SSL_KEY),
      SSLEnable: true,
      SSLCertName: cert_name
    }
  end

  
  DATABASE_CREDENTIALS = {adapter: "sqlite", database: "pact_broker_ssl_database.sqlite3", :encoding => "utf8"}
  
  require "pact_broker"

  require "webrick"
  require "webrick/https"
  require "rack"
  require "rack/handler/webrick"

  app = PactBroker::App.new do | config |
    config.log_stream = "stdout"
    config.log_level = "debug"
    config.database_connection = Sequel.connect(DATABASE_CREDENTIALS)
  end

  opts = webrick_opts(4444)

  Rack::Handler::WEBrick.run(app, opts) do |server|
    @server = server
  end
end
