require 'spec_helper'

describe Kohawk::Exchange do

  subject { Kohawk::Exchange.new(context) }

  let(:context) { double('context', :channel => nil, :queue_definition => queue_definition) }
  let(:queue_definition) {
    {
      :exchange => {
        name: "test",
        type: :topic,
        options: {durable: true}
      }
    }
  }

  describe "public methods" do
    it { should respond_to(:context) }
    it { should respond_to(:exchange) }
    it { should respond_to(:create) }
    it { should respond_to(:name) }
    it { should respond_to(:type) }
    it { should respond_to(:options) }
    it { should respond_to(:queue_definition) }
  end

  describe "#create" do

    it "creates an exchange" do
      expect(Bunny::Exchange).to receive(:new).with(context.channel, queue_definition[:exchange][:type], queue_definition[:exchange][:name], queue_definition[:exchange][:options])
      subject.create
    end
  end

end
