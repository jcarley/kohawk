require 'spec_helper'

describe Kohawk::Queue do

  let(:event_name) { "" }
  let(:handler) { ['', "app:#{event_name}:test", ''] }
  let(:queue) { double("queue") }
  let(:channel) { double('channel', :queue => queue) }

  subject { Kohawk::Queue.new(event_name, handler, channel) }

  describe "public methods" do
    it { should respond_to(:queue) }
    it { should respond_to(:channel) }
    it { should respond_to(:to_routing_key) }
    it { should respond_to(:queue_name) }
    it { should respond_to(:declare_queue) }
  end

  describe "#declare_queue" do
    it "creates a queue" do
      subject.declare_queue
      expect(subject.queue).to_not be_nil
    end
  end

  describe "#to_routing_key" do
    let(:event_name) { "first_name_changed" }

    it "converts the event name to a routing key" do
      expect(subject.to_routing_key).to eql("first.name.changed")
    end

  end

  describe "#queue_name" do
    it "returns the queue name" do
      expect(subject.queue_name).to eql("app:#{event_name}:test")
    end
  end

end

