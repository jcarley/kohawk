module Kohawk
  class EventDispatcher

    def self.default_middleware
      Kohawk::Middleware::Chain.new do |m|
      end
    end

    def process(channel_proxy)

      queue_name = channel_proxy.queue_name
      chain = Kohawk.configuration.middleware

      Kohawk.configuration.routes.subscribers_for(queue_name) do |handlers|

        handlers.each do |handler|
          puts handler.inspect
          klass = handler[0].new
          klass.send(handler[1], channel_proxy)
        end

      end

    end

  end
end
