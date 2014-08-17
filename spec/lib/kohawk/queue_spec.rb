require 'spec_helper'

describe Kohawk::Queue do

  subject { Kohawk::Queue.new(context) }

  let(:context) { double('context', :channel => channel, :queue_name => "test_queue", :queue_definition => queue_definition) }
  let(:channel) { double('channel') }
  let(:queue_definition) {
    {
      options: { durable: true }
    }
  }
  let(:queue) { double('queue') }

  describe "public methods" do
    it { should respond_to(:context) }
    it { should respond_to(:queue) }
    it { should respond_to(:create) }
    it { should respond_to(:name) }
    it { should respond_to(:options) }
    it { should respond_to(:queue_definition) }
  end

  describe "#create" do

    it "creates a queue" do
      expect(channel).to receive(:queue).with(context.queue_name, queue_definition[:options])
      subject.create
    end

    it "returns an instance of a queue" do
      allow(channel).to receive(:queue).with(context.queue_name, queue_definition[:options]).and_return(queue)
      expect(subject.create).to be(queue)
    end

  end

end

