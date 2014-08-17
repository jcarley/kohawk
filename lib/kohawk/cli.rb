module Kohawk
  class CLI

    attr_reader :logger

    def initialize(logger = nil)
      @logger = logger
    end

    def start

      connect(:default) do |connection|

        Kohawk.configuration.routes.queues.each_pair do |queue_name, queue_definition|

          channel = connection.create_channel

          context = BindingContext.new(channel, queue_name, queue_definition)
          exchange = Exchange.new(context)
          queue = Queue.new(context)
          binding = Binding.new(context, exchange, queue)


          subscribers = Kohawk.configuration.routes.subscribers[queue_name]
          subscribers.each do |handler|
            klass = handler[0]
            method = handler[1]
          end

        end

        EventDispatcher.subscribers.each do |event_name, handlers|

          handlers.each do |handler|
            # ["AssetCreateHandler", "ice::private_content_update::asset_create_handler", :test_handle]

            # ---------Queue-----------
            queue_name = handler[1]
            routing_key = to_routing_key(event_name)

            logger.info("Declaring queue #{queue_name} ...")
            q  = channel.queue(queue_name, {:durable => true, :auto_delete => true})

            # ---------Binding-----------
            logger.info("Binding queue #{queue_name} to routing key #{routing_key} ...")
            q.bind(x, :routing_key => routing_key)


            # ---------Consumer-----------
            consumer = consumer_class.new(channel, q, "", false, false)

            consumer.on_delivery() do |delivery_info, metadata, payload|
              log("Received event: #{event_name}")
              channel_message_store = ChannelMessageStore.new(event_name, channel, delivery_info, metadata, payload)
              database_message_store = DatabaseMessageStore.new(channel_message_store)
              event_dispatcher = EventDispatcher.new(database_message_store)
              event_dispatcher.process
            end

            log("Subscribing to #{queue_name} with a #{consumer_class} consumer ...")
            q.subscribe_with(consumer, :block => false)


            queue = Queue.new(event_name, handler, channel)
            binding = Binding.new(x, queue)
            consumer = Consumer.new(binding)

          end

        end

      end

    end

    def stop
      ConnectionManager.disconnect_all
    end

    def exchange_name
      Kohawk.configuration.exchange_name
    end

    def to_routing_key(event_name)
      event_name.to_s.gsub("_", ".")
    end

    private

    def connect(name)
      options = Kohawk.configuration.connect_options
      options = options.merge(:name => name)
      connection = ConnectionManager.instance.connect(options)
      block.call(connection) if block_given?
    end

  end
end

