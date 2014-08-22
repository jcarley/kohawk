require 'spec_helper'

class TestHandler
  def handle(channel_proxy)
  end
end

describe Kohawk::EventDispatcher do

  describe "public methods" do
    it { should respond_to(:process).with(1).arguments }
  end

  describe '#process' do

    before(:each) do
      Kohawk.configuration.routes.draw do

        topic :exampleapp, :options => {:durable => true, :auto_delete => true} do
          queue 'app:person:create', :bindings => ['app.person.create'], :options => {durable: true, auto_delete: true}, :as => :person_create
          queue 'app:person:update', :bindings => ['app.person.update'], :options => {durable: true, auto_delete: true}, :as => :person_update
        end

        subscribe queue: :person_create, handler: 'test#handle'
        subscribe queue: :person_update, handler: 'person#update'

      end
    end

    subject { Kohawk::EventDispatcher.new }

    it 'calls each handler for an event' do
      channel_proxy = double('channel_proxy', :queue_name => :person_create)
      expect_any_instance_of(TestHandler).to receive(:handle).with(channel_proxy)
      subject.process(channel_proxy)
    end

  end


end
