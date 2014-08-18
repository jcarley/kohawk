require 'bunny'

module Kohawk
  module Adapters
    class Bunny
      extend Forwardable

      attr_reader :session

      def_delegators :@session, :create_channel

      def connect(options)
        if session.nil?
          @session = ::Bunny.new(options)
          session.start
        end
        session
      end

      def disconnect
        unless session.nil?
          session.stop
          @session = nil
        end
      end

    end
  end
end
