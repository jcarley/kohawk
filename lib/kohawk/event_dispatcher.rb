module Kohawk
  class EventDispatcher

    def self.subscribers
      @subscribers ||= {}
    end

    def self.subscribers_for(event_name)
      event_name = event_name.to_sym if event_name.is_a?(String)
      if subscribers.has_key?(event_name)
        subscribers[event_name]
      else
        []
      end
    end

    def self.subscribe(event_name, class_name, handler_id, handler)
      (subscribers[event_name] ||= []) << [class_name, handler_id, handler]
    end

    def self.clear
      subscribers.clear
    end

    def self.default_middleware
      Kohawk::Middleware::Chain.new do |m|
      end
    end

    def process(channel_proxy)
      @channel_proxy = channel_proxy

      current_event = channel_proxy.current_event
      event_name = current_event.routing_key.gsub(".", "_").to_sym

      EventDispatcher.subscribers_for(event_name).each do |subscriber|

        chain = Kohawk.configuration.middleware

        klass = subscriber[0].constantize
        handler = klass.new
        handler_method = subscriber[2]
        handler.send(handler_method, current_event, channel_proxy)

      end
    end

  end
end
