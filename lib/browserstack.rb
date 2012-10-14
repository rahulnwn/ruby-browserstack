require "base64"
require "net/http"
require "yajl"
require "browserstack/client"
require "browserstack/version"

module Browserstack
  def self.create_client(params)
    client = Client.new(params)
    puts "Client created"
    client
  end
end
