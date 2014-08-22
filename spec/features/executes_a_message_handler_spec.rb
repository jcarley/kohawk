require 'spec_helper'
require 'JSON'

describe "Execute message handler" do

  before(:context) do

    Kohawk.configuration do |config|
      config.host     = "127.0.0.1"
      config.vhost    = "local"
      config.port     = 5672
      config.user     = "dev"
      config.password = "dev"
    end

    Kohawk.configuration.routes.draw do

      topic :exampleapp, :options => {:durable => true, :auto_delete => true} do
        queue 'app:person:create', :bindings => ['app.person.create'], :options => {durable: true, auto_delete: true}, :as => :person_create
        queue 'app:person:update', :bindings => ['app.person.update'], :options => {durable: true, auto_delete: true}, :as => :person_update
      end

      subscribe queue: :person_create, handler: 'person#create'
      subscribe queue: :person_create, handler: 'asset#create'
      # subscribe queue: :person_update, handler: 'person#update'

    end

    @cli = Kohawk::CLI.new
    @cli.start
  end

  after(:context) do
    @cli.stop
  end

  context "when a message is received" do

    specify "it will be routed to all message handlers that have subscribed to it" do

      headers = {version: 1}
      routing_key = "app.person.create"
      payload = JSON.generate({message: "hello"})

      Helpers.publish_message(payload, routing_key, headers)

    end

  end

end

