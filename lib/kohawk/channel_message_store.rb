module Kohawk
  class ChannelMessageStore

    attr_reader :queue_name, :channel, :delivery_info, :metadata, :payload

    def initialize(queue_name, ch, delivery_info, metadata, payload)
      @queue_name = queue_name
      @channel = ch
      @delivery_info = delivery_info
      @metadata = metadata
      @payload = payload
    end

    def accept
      channel.acknowledge(delivery_info.delivery_tag)
    end
    alias_method :acknowledge, :accept

    def reject
      channel.reject(delivery_info.delivery_tag, false)
    end

    def requeue
      channel.reject(delivery_info.delivery_tag, true)
    end

  end
end
