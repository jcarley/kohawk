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

      def exists?(klass)
        any? { |k| k.klass == klass }
      end

      def invoke(event, channel_proxy)
        yield event, channel_proxy if block_given?
      end

    end

    class MiddlewareEntry
      attr_reader :klass

      def initialize(klass, *args)
        @klass = klass
        @args = args
      end

    end
  end
end
