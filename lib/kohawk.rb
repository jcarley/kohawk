require 'kohawk/version'
require 'kohawk/cli'
require 'kohawk/binding'
require 'kohawk/core_ext'
require 'kohawk/queue'
require 'kohawk/router'
require "kohawk/event_dispatcher"
require 'kohawk/configuration'
require 'kohawk/connection_manager'
require 'kohawk/middleware/chain'
require 'kohawk/adapters/bunny'

module Kohawk
  def self.configuration
    @configuration ||= Kohawk::Configuration.new
    yield @configuration if block_given?
    @configuration
  end
end
