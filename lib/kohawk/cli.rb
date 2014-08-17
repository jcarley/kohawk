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

          context  = BindingContext.new(channel, queue_name, queue_definition)
          exchange = Exchange.new(context)
          binding  = Binding.new(context, exchange)
          queue    = Queue.new(context)
          binding.bind(queue)

          consumer = Consumer.new(context, queue)
          consumer.listen

          subscribers = Kohawk.configuration.routes.subscribers[queue_name]
          subscribers.each do |handler|
            klass = handler[0]
            method = handler[1]
          end

        end

      end

    end

    def stop
      ConnectionManager.disconnect_all
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

