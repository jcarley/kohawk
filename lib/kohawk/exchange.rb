module Kohawk
  class Exchange

    attr_reader :context, :exchange

    def initialize(context)
      @context = context
    end

    def create
      @exchange ||= ::Bunny::Exchange.new(context.channel, type, name, options)
    end

    def name
      queue_definition[:exchange][:name]
    end

    def type
      queue_definition[:exchange][:type]
    end

    def options
      queue_definition[:exchange][:options] || {}
    end

    def queue_definition
      context.queue_definition
    end

  end
end
