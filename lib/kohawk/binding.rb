module Kohawk
  class Binding

    attr_reader :context, :exchange

    def initialize(context, exchange)
      @context = context
      @exchange = exchange
    end

    def bind(queue)
      # logger.info("Binding queue #{queue_name} to #{binding} ...")
      bindings.each do |binding|
        x = exchange.create
        q = queue.create
        q.bind(x, :routing_key => binding)
      end
    end

    def bindings
      queue_definition[:bindings]
    end

    def queue_definition
      context.queue_definition
    end

  end
end

