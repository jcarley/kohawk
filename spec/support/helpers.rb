require 'bunny'

module Helpers

  def self.connect(&block)
    connect_options = Kohawk.configuration.connect_options
    Bunny.run(connect_options, &block)
  end

  def self.declare_exchange(session, exchange_name, opts = {})
    options = {:auto_delete => true, :durable => true}.merge(opts)
    session.topic(exchange_name, options)
  end

  def self.publish_message(payload, routing_key, headers, opts = {})
    connect do |session|
      exchange_name = opts[:exchange_name] || "exampleapp"
      exchange = declare_exchange(session, exchange_name)
      exchange.publish(
        payload,
        routing_key: routing_key,
        headers: headers,
        timestamp: Time.now.to_i,
        correlation_id: SecureRandom.uuid,
        message_id: SecureRandom.uuid)
    end
  end

end
