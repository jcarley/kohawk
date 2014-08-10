module Kohawk
  module Middleware
    class Chain
      include Enumerable

      attr_reader :entries

      def initialize
        @entries = []
        yield self if block_given?
      end

      def each(&block)
        entries.each(&block)
      end

      def add(klass, *args)
        remove(klass) if exists?(klass)
        @entries << MiddlewareEntry.new(klass, args)
      end

      def remove(klass)
        entries.delete_if { |k| k.klass == klass }
      end

      def retrieve
        entries.map(&:to_instance)
      end

      def exists?(klass)
        any? { |k| k.klass == klass }
      end

      def invoke(event, channel_proxy, &final_action)
        chain = retrieve.dup
        invoke_chain = lambda do |event, channel_proxy|
          if chain.empty?
            final_action.call(event, channel_proxy)
          else
            chain.shift.call(event, channel_proxy, &invoke_chain)
          end
        end
        invoke_chain.call(event, channel_proxy)
      end

    end

    class MiddlewareEntry
      attr_reader :klass

      def initialize(klass, *args)
        @klass = klass
        @args = args
      end

      def to_instance
        @klass.new(*@args)
      end

    end
  end
end
