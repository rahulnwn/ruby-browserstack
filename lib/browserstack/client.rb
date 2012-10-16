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
        call = Net::HTTP::Get.new("/#{self.version}/browsers")
        @browsers = parse make_request(call)
        @latest_update = Time.now
      end
      return_with_os(os)
    end

    def create_worker(settings)
      settings ||= {}
      call = Net::HTTP::Post.new("/#{self.version}/worker")
      call.set_form_data(settings)
      data = parse make_request(call)
      data[:id]
    end

    def terminate_worker(worker_id)
      call = Net::HTTP::Delete.new("/#{self.version}/worker/#{worker_id}")
      parse make_request(call)
    end

    def get_worker_status(worker_id)
      call = Net::HTTP::Get.new("/#{self.version}/worker/#{worker_id}")
      parse make_request(call)
    end

    def get_workers
      call = Net::HTTP::Get.new("/#{self.version}/workers")
      parse make_request(call)
    end

    def get_supported_os_list
      get_browsers.keys.map { |os| os.to_s }
    end

    private
    def create_new_connection
      Net::HTTP.new(HOSTNAME, 80)
    end

    def parse(response)
      parser = Yajl::Parser.new(:symbolize_keys => true)
      parser.parse(response.body)
    end

    def add_authentication(call)
      call["Authorization"] = @authentication
    end
    
    def make_request(call)
      connection = create_new_connection
      add_authentication(call)
      res = connection.request(call)
      case res.code.to_i
      when 200
        res
      when 401
        raise "Unauthorized User"
      when 422, 403
        raise_validation_error(res)
      else
        raise res.body
      end
    end

    def raise_validation_error(res)
      parser = Yajl::Parser.new(:symbolize_keys => true)
      data = parser.parse(res.body)
      message = "#{data[:message]}\n"
      data[:errors].each { |error| message << "#{error[:field]} : #{error[:code]}\n" }
      raise message
    end

    def update_cache?
      @latest_update.nil? || (Time.now - @latest_update > 86400) #cache for one day
    end

    def return_with_os(os)
      os ? @browsers[os.to_sym] : @browsers
    end
  end
end
