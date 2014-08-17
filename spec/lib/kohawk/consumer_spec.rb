require 'spec_helper'

describe Kohawk::Consumer do

  subject { Kohawk::Consumer.new(context, queue) }

  let(:context) { double('context', :channel => channel) }
  let(:queue) { double('queue', :create => q) }
  let(:channel) { double('channel') }
  let(:q) { double('q', :subscribe_with => nil) }
  let(:consumer) { double('consumer', :on_delivery => nil) }

  before(:each) do
    allow(Bunny::Consumer).to receive(:new).with(channel, q, "", false, false).and_return(consumer)
  end

  describe "public methods" do
    it { should respond_to(:context) }
    it { should respond_to(:queue) }
    it { should respond_to(:listen) }
  end

  describe '#listen' do

    it 'creates a new consumer' do
      expect(consumer).to receive(:on_delivery).once
      expect(q).to receive(:subscribe_with).with(consumer, :block => false)
      subject.listen
    end

  end

end

