require 'spec_helper'

describe Kohawk::Binding do

  subject { Kohawk::Binding.new(context, exchange, queue) }

  let(:context) { double('context', :queue_definition => queue_definition) }
  let(:exchange) { double('exchange', :create => x) }
  let(:x) { double('x') }
  let(:queue) { double('queue', :create => q) }
  let(:q) { double('q') }
  let(:queue_definition) { {:bindings => bindings } }
  let(:bindings) { ['app:event:handler'] }


  describe "public methods" do
    it { should respond_to(:context) }
    it { should respond_to(:exchange) }
    it { should respond_to(:queue) }
    it { should respond_to(:create) }
    it { should respond_to(:queue_definition) }
    it { should respond_to(:bindings) }
  end

  describe "#create" do

    it "sets up the queue's bindings" do
      expect(exchange).to receive(:create)
      expect(queue).to receive(:create)
      expect(q).to receive(:bind).once.with(x, :routing_key => 'app:event:handler')
      subject.create
    end
  end

end

