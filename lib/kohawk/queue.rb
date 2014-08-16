module Kohawk
  class Queue

    attr_reader :event_name, :handler, :queue, :channel

    def initialize(event_name, handler, channel)
      @event_name = event_name
      @handler = handler
      @channel = channel
    end

    def declare_queue
      @queue = channel.queue(queue_name, {:durable => true, :auto_delete => true})
    end

    def queue_name
      handler[1]
    end

    def to_routing_key
      event_name.to_s.gsub("_", ".")
    end

  end
end
