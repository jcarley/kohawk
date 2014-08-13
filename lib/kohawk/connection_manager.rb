require 'singleton'

module Kohawk
  class ConnectionManager
    include Singleton

    attr_reader :connections

    def initialize
      @connections = {}
    end

    def connect(options)
      connection_name = (options[:name] || :default).to_sym
      if connections[connection_name].nil?
        adapter = Kohawk.configuration.adapter
        adapter.connect(options)
        connections[connection_name] = adapter
      end
      connections[connection_name]
    end

    def disconnect(name = nil)
      connection_name = (name || :default).to_sym
      unless connections[connection_name].nil?
        adapter = connections[connection_name]
        adapter.disconnect
        connections[connection_name] = nil
      end
    end

    def disconnect_all
      connections.each_pair do |key, value|
        value.disconnect
        connections[key] = nil
      end
      connections.clear
    end

  end
end

