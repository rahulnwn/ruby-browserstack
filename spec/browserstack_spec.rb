require 'spec_helper'

describe Browserstack do
  describe "create_client" do
    it "should create a new client object" do
      @client = Browserstack.create_client(username: "foo", password: "testing")
      @client.should be_an_instance_of(Browserstack::Client)
    end
  end
end
