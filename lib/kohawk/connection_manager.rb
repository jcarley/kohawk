require 'singleton'

module Kohawk
  class ConnectionManager
    include Singleton

    attr_reader :session

    def connect(options)
      if session.nil?
        @session = Bunny.new(options)
        session.start
      end
      session
    end

    def disconnect
      if session.nil?
        session.stop
        @session = nil
      end
    end

  end
end

