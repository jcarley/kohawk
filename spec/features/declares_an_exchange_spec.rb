require 'spec_helper'
require 'rest-client'

describe 'An exchange defined in the routes file' do

  it 'is created on startup' do

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

    end

    cli = Kohawk::CLI.new
    cli.start

    url = 'http://dev:dev@127.0.0.1:15672/api/exchanges/local/exampleapp'
    RestClient.get url, {:accept => :json} do |response, request, result, &block|
      case response.code
      when 200
        body = JSON.load(response.body)
        expect(body["name"]).to eql("exampleapp")
        expect(body["vhost"]).to eql("local")
        expect(body["durable"]).to be(true)
        expect(body["auto_delete"]).to be(true)
      else
        fail
      end
    end

    # binding.pry
  end

end
