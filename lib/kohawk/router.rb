module Kohawk
  class Router

    attr_reader :route_set, :exchanges, :queues

    def initialize
      @exchanges = {}
      @queues = {}
    end

    def clear!

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
      @router.add_queue(name, opts.merge(:exchange => @exchange_scope))
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
