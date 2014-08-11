module Kohawk
  class Configuration

    attr_accessor :host, :vhost, :port, :user, :password, :exchange_name

    def middleware
      @middleware ||= EventDispatcher.default_middleware
      yield @middleware if block_given?
      @middleware
    end

    def adaptor
      @adaptor ||= Kohawk::Adaptors::BunnyAdaptor.new
    end

    def adaptor=(adaptor)
      @adaptor = adaptor
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
