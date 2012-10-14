require 'spec_helper'

describe Browserstack::Client do
  before do
    @params = {username: "foobar", password: "1234"}
    @client = Browserstack::Client.new(@params)
  end

  describe "#initialize" do
    it "should create a new client object" do
      @client.should be_an_instance_of(Browserstack::Client)
    end

    it "should raise an error without username params" do
      @params.delete(:username)
      expect { Browserstack::Client.new(@params) }.to raise_error("Username is required")
    end

    it "should raise an error without password params" do
      @params.delete(:password)
      expect { Browserstack::Client.new(@params) }.to raise_error("Password is required")
    end

    it "should set API version as 2" do
      @client.version.should == 2
    end

  end

  describe "get_broswers" do
    before do
      @browsers = "{\"ios\":[{\"device\":\"iPhone 3GS\",\"version\":\"3.0\"}],\"android\":[{\"device\":\"Samsung Galaxy S\",\"version\":\"2.1\"}],\"mac\":[{\"version\":\"4.0\",\"browser\":\"safari\"}],\"win\":[{\"version\":\"4.0\",\"browser\":\"safari\"}]}"
      stub_request(:get, "http://#{@params[:username]}:#{@params[:password]}@api.browserstack.com/#{@client.version}/browsers").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => @browsers, :headers => {})
      parser = Yajl::Parser.new(:symbolize_keys => true)
      @parsed_data = parser.parse(@browsers)
    end

    context "when no os argument passed" do
      it "should return a hash of all os browsers" do
        browsers = @client.get_browsers
        browsers.should == @parsed_data
      end

      it "should update cache depending on last updated" do
        browsers = @client.get_browsers
        @client.stub("update_cache?").and_return(true)
        @browsers = "{\"ios\":[{\"device\":\"iPhone 3GS\",\"version\":\"3.0\"}],\"android\":[{\"device\":\"Samsung Galaxy S\",\"version\":\"2.1\"}],\"mac\":[{\"version\":\"4.0\",\"browser\":\"safari\"}]}"
        stub_request(:get, "http://#{@params[:username]}:#{@params[:password]}@api.browserstack.com/#{@client.version}/browsers").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => @browsers, :headers => {})
        updated_browsers = @client.get_browsers
        updated_browsers[:win].should be_nil
      end
    end

    context "when os argument passed" do
      it "should return a hash of browsers of that os" do
        browsers = @client.get_browsers(:win)
        browsers.should == @parsed_data[:win]
      end

      it "should return nil if invalid argument passed" do
        browsers = @client.get_browsers("windows7")
        browsers.should be_nil
      end
    end
  end

  descirbe "create_worker" do

  end

  descirbe "terminate_worker" do

  end

  descirbe "get_worker_status" do

  end

  descirbe "get_workers" do

  end

  descirbe "get_supported_os_list" do

  end
end
