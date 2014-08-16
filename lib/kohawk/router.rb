module Kohawk
  class Router

    attr_reader :exchanges, :queues, :subscribers

    class NonExistentQueueError < StandardError; end;
    class DuplicateHandlerSubscriptionError < StandardError; end;
    class QueueRequiredForSubscriptionError < StandardError; end;
    class HandlerRequiredForSubscriptionError < StandardError; end;

    def initialize
      @exchanges = {}
      @queues = {}
      @subscribers = {}
    end

    def clear!
      @exchanges = @exchanges.clear
      @queues = @queues.clear
    end

    def draw(&block)
      clear!
      eval_block(block)
    end

    def eval_block(block)
      mapper = Mapper.new(self)
      mapper.instance_exec(&block)
    end

    def add_exchange(name, opts = {})
      (@exchanges[name] ||= {}).merge!(opts)
    end

    def add_queue(name, opts = {})
      (@queues[name] ||= {}).merge!(opts)
    end

    def add_subscriber(queue_name, handler_entry)
      raise NonExistentQueueError unless queues.has_key?(queue_name)
      raise DuplicateHandlerSubscriptionError if (subscribers[queue_name] || []).include?(handler_entry)
      (@subscribers[queue_name] ||= []) << handler_entry
    end

  end

  class Mapper

    attr_accessor :default_exchange

    def initialize(router)
      @default_exchange = {:name => 'default', :type => :topic}
      @exchange_scope = @default_exchange
      @router = router
    end

    def exchange(name, opts = {})
      @exchange_scope = {:name => name}.merge(opts)
      @router.add_exchange(name, opts)
      yield if block_given?
      @exchange_scope = @default_exchange
    end

    def topic(name, opts = {}, &block)
      exchange(name, opts.merge(:type => :topic), &block)
    end

    def queue(name, opts = {})
      opts = opts.merge(:name => name, :exchange => @exchange_scope)
      name = opts.delete(:as) || name
      @router.add_queue(name, opts)
    end

    def subscribe(opts)
      queue_name = opts[:queue]
      handler = opts[:handler]
      raise Kohawk::Router::QueueRequiredForSubscriptionError if queue_name.nil? || queue_name.empty?
      raise Kohawk::Router::HandlerRequiredForSubscriptionError if handler.nil? || handler.empty?
      handler_entry = parse_handler(handler)
      @router.add_subscriber(queue_name, handler_entry)
    end

    private

    def parse_handler(handler_mapping)
      fragments = handler_mapping.split('#')
      ["#{fragments[0]}_handler".camelize.constantize, fragments[1].to_sym]
    end

  end

end


# topic 'dsa' do
  # queue 'istock:asset:create', :bindings => ['private.asset.create'], :as => :asset_create
  # queue 'istock:content:update', :bindings => ['private.content.update'], :as => :asset_update
# end

# subscribe queue: 'asset:create', handler: 'asset_create#test_handle'
# subscribe queue: 'asset:update', handler: 'content_update#test_handle'

# publish queue: 'ice:events'






