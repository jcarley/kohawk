require 'spec_helper'

class TestHandler
  def handle(event, channel_proxy)
  end
end

describe Kohawk::EventDispatcher do

  before(:each) do
    Kohawk::EventDispatcher.clear
  end

  describe "class public methods" do
    subject { Kohawk::EventDispatcher }
    it { should respond_to(:subscribe).with(4).arguments }
    it { should respond_to(:subscribers) }
  end

  describe ".clear" do
    subject { Kohawk::EventDispatcher }

    it 'removes all subscriptions' do
      subject.subscribe(:first_name_changed, "TestHandler", "app:firt_name_changed:test_handler", "handle")
      subject.clear
      expect(subject.subscribers.count).to eql(0)
    end
  end

  describe ".subscribe" do
    subject { Kohawk::EventDispatcher }

    it 'adds a subscriber to the subscribers list' do
      subject.subscribe(:first_name_changed, "TestHandler", "app:firt_name_changed:test_handler", "handle")
      expect(subject.subscribers.count).to eql(1)
    end

    it 'adds a handler array structure for an event_name' do
      subject.subscribe(:first_name_changed, "TestHandler", "app:firt_name_changed:test_handler", "handle")
      expect(subject.subscribers[:first_name_changed]).to eql([["TestHandler", "app:firt_name_changed:test_handler", "handle"]])
    end

  end

  describe ".self.subscribers_for" do
    subject { Kohawk::EventDispatcher }

    it "returns an empty array for an unknow event name" do
      expect(subject.subscribers_for(:unknown_event)).to eql([])
    end

  end

  describe '#process' do

    subject { Kohawk::EventDispatcher.new }

    it 'calls each handler for an event' do
      Kohawk::EventDispatcher.subscribe(:first_name_changed, "TestHandler", "app:firt_name_changed:test_handler", "handle")
      event = double('first_name_changed_event', :routing_key => 'first_name.changed')
      channel_proxy = double('channel_proxy', :current_event => event)
      expect_any_instance_of(TestHandler).to receive(:handle).with(event, channel_proxy)
      subject.process(channel_proxy)
    end

  end


end
