module Browserstack
  HOSTNAME = "api.browserstack.com"
  class Client
    attr_reader :browsers, :version

    def initialize(params)
      params ||= {}

      raise ArgumentError, "Username is required" unless params[:username]
      raise ArgumentError, "Password is required" unless params[:password]

      @authentication = "Basic " + Base64.encode64("#{params[:username]}:#{params[:password]}").strip

      @version = 2
    end

    def get_browsers(os = nil)
      if update_cache?
        connection = create_new_connection
        call = Net::HTTP::Get.new("/#{self.version}/browsers")
        add_authentication(call)
        res = make_request(connection, call)
        @latest_update = Time.now
        parser = Yajl::Parser.new(:symbolize_keys => true)
        @browsers = parser.parse(res.body)
      end
      return_with_os(os)
    end

    def create_worker(settings)
      settings ||= {}
      connection = create_new_connection
      call = Net::HTTP::Post.new("/#{self.version}/worker")
      call.set_form_data(settings)
      add_authentication(call)
      res = make_request(connection, call)
      Yajl::Parser.parse(res.body)['id']
    end

    def terminate_worker(worker_id)
      connection = create_new_connection
      call = Net::HTTP::Delete.new("/#{self.version}/worker/#{worker_id}")
      add_authentication(call)
      res = make_request(connection, call)
      parser = Yajl::Parser.new(:symbolize_keys => true)
      parser.parse(res.body)
    end

    def get_worker_status(worker_id)
      connection = create_new_connection
      call = Net::HTTP::Get.new("/#{self.version}/worker/#{worker_id}")
      add_authentication(call)
      res = make_request(connection, call)
      parser = Yajl::Parser.new(:symbolize_keys => true)
      parser.parse(res.body)
    end

    def get_workers
      connection = create_new_connection
      call = Net::HTTP::Get.new("/#{self.version}/workers")
      add_authentication(call)
      res = make_request(connection, call)
      parser = Yajl::Parser.new(:symbolize_keys => true)
      parser.parse(res.body)
    end

    def get_supported_os_list
      get_browsers.keys.map { |os| os.to_s }
    end

    private
    def create_new_connection
      Net::HTTP.new(HOSTNAME, 80)
    end

    def add_authentication(call)
      call["Authorization"] = @authentication
    end
    
    def make_request(connection, call)
      res = connection.request(call)
      case res.code.to_i
      when 200
        res
      when 401
        raise "Unauthorized User".inspect
      when 422
        raise_validation_error
      else
        raise res.body.inspect
      end
    end

    def raise_validation_error
      raise res.body.inspect
    end

    def update_cache?
      @latest_update.nil? || (Time.now - @latest_update > 86400) #cache for one day
    end

    def return_with_os(os)
      os ? @browsers[os.to_sym] : @browsers
    end
  end
end
