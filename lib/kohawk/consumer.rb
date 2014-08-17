module Kohawk
  class Consumer

    attr_reader :context, :queue

    def initialize(context, queue)
      @context = context
      @queue = queue
    end

    def listen
      q = queue.create

      consumer = Bunny::Consumer.new(context.channel, q, "", false, false)

      consumer.on_delivery() do |delivery_info, metadata, payload|
        channel_message_store = ChannelMessageStore.new(queue.name, context.channel, delivery_info, metadata, payload)
        event_dispatcher = EventDispatcher.new(channel_message_store)
        event_dispatcher.process
      end

      q.subscribe_with(consumer, :block => false)
    end

  end

end

