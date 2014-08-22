require 'spec_helper'

describe Kohawk::ChannelMessageStore do

  subject { Kohawk::ChannelMessageStore.new(queue_name, channel, delivery_info, metadata, payload) }

  let(:queue_name) { "app:test:queue" }
  let(:channel) { double('channel', :acknowledge => nil, :reject => nil) }
  let(:delivery_info) { double('delivery_info', :delivery_tag => "1234567890") }
  let(:metadata) { double('metadata') }
  let(:payload) { double('payload') }

  describe "public methods" do
    it { should respond_to(:accept) }
    it { should respond_to(:acknowledge) }
    it { should respond_to(:reject) }
    it { should respond_to(:requeue) }
    it { should respond_to(:queue_name) }
    it { should respond_to(:channel) }
    it { should respond_to(:delivery_info) }
    it { should respond_to(:metadata) }
    it { should respond_to(:payload) }
  end

  describe "#accept" do
    it "acknowledges the message" do
      subject.accept
      expect(channel).to have_received(:acknowledge).with(delivery_info.delivery_tag)
    end
  end

  describe "#reject" do
    it "rejects and does not requeue the message" do
      subject.reject
      expect(channel).to have_received(:reject).with(delivery_info.delivery_tag, false)
    end
  end

  describe "#requeue" do
    it "rejects and requeue the message" do
      subject.requeue
      expect(channel).to have_received(:reject).with(delivery_info.delivery_tag, true)
    end
  end

end

