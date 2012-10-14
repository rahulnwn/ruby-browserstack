require File.expand_path("../../lib/browserstack", __FILE__)
require 'webmock/rspec'
RSpec.configure do |config|
  #config.mock_with :rspec
end

WebMock.disable_net_connect!(:allow_localhost => true)
