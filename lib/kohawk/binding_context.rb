module Kohawk
  class BindingContext
    attr_reader :channel, :queue_name, :queue_definition

    def initialize(channel, queue_name, queue_definition)
      @channel = channel
      @queue_name = queue_name
      @queue_definition = queue_definition
    end
  end
end
