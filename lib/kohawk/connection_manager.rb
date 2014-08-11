require 'singleton'

module Kohawk
  class ConnectionManager
    include Singleton

    attr_reader :adapter

    def connect(options)
      if adapter.nil?
        @adapter = Kohawk.configuration.adapter
        adapter.connect(options)
      end
      adapter
    end

    def disconnect
      unless adapter.nil?
        adapter.disconnect
        @adapter = nil
      end
    end

  end
end

