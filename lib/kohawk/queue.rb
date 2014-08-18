module Kohawk
  class Queue

    attr_reader :context, :queue

    def initialize(context)
      @context = context
    end

    def create
      @queue ||= context.channel.queue(name, options)
    end

    def name
      context.queue_name
    end

    def options
      queue_definition[:options] || {}
    end

    def queue_definition
      context.queue_definition
    end

  end
end
