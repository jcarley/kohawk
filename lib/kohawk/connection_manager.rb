require 'singleton'
require 'bunny'

module Kohawk
  class ConnectionManager
    include Singleton

    attr_reader :adaptor

    def connect(options)
      if adaptor.nil?
        @adaptor = Kohawk.configuration.adaptor
        adaptor.connect(options)
      end
      adaptor
    end

    def disconnect
      unless adaptor.nil?
        adaptor.disconnect
        @adaptor = nil
      end
    end

  end
end

