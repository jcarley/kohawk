require "kohawk/version"
require "kohawk/configuration"
require "kohawk/connection_manager"

module Kohawk
  def self.configuration
    @configuration ||= Kohawk::Configuration.new
    yield @configuration if block_given?
    @configuration
  end
end
