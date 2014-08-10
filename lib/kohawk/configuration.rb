module Kohawk
  class Configuration

    attr_accessor :host, :vhost, :port, :user, :password

    def exchange_name
      @exchange_name || "dsa"
    end

    def exchange_name=(value)
      @exchange_name = value
    end

    def middleware
      @middleware ||= EventDispatcher.default_middleware
      yield @middleware if block_given?
      @middleware
    end

    def connect_options
      {
        :host  => host,
        :vhost => vhost,
        :port  => port,
        :user  => user,
        :pass  => password
      }
    end

  end
end
