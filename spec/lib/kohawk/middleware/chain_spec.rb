require 'spec_helper'

class TestMiddleware
  def initialize(msg)
  end
end
class TestMiddleware2
  def initialize(msg)
  end
end
class TestMiddleware3
  def initialize(msg)
  end
end

describe Kohawk::Middleware::Chain do

  describe "public methods" do
    it { should respond_to(:entries) }
    it { should respond_to(:each) }
    it { should respond_to(:add).with(2).arguments }
    it { should respond_to(:remove).with(1).argument }
    it { should respond_to(:retrieve) }
    it { should respond_to(:exists?).with(1).arguments }
    it { should respond_to(:invoke).with(2).arguments }
  end

  describe "#initialize" do

    it "yields itself when a block is given" do
      expect { |b| Kohawk::Middleware::Chain.new(&b) }.to yield_with_args(Kohawk::Middleware::Chain)
    end

    it "initializes entries as an empty array" do
      chain = Kohawk::Middleware::Chain.new
      expect(chain.entries).to eql([])
    end

  end

  describe "#add" do

    it "adds middleware to the chain" do
      subject.add(TestMiddleware, "hello")
      expect(subject.entries.count).to eql(1)
    end

    it "adds an instance of a MiddlewareEntry" do
      subject.add(TestMiddleware, "hello")
      expect(subject.entries[0]).to be_instance_of(Kohawk::Middleware::MiddlewareEntry)
    end

    it "does not add multiple entries of the same type" do
      subject.add(TestMiddleware, "hello")
      subject.add(TestMiddleware, "hello")
      expect(subject.entries.count).to eql(1)
    end

  end

  describe "#remove" do

    it "removes the MiddlewareEntry from the collection" do
      subject.add(TestMiddleware, "hello")
      subject.remove(TestMiddleware)
      expect(subject.entries.count).to eql(0)
    end

  end

  describe "#retrieve" do

    before(:each) do
      subject.add(TestMiddleware, "hello")
      subject.add(TestMiddleware2, "hello2")
      subject.add(TestMiddleware3, "hello3")
    end

    it "returns an array of middleware objects" do
      expect(subject.retrieve).to be_instance_of(Array)
    end

    it "returns instances of each middleware object" do
      middleware = subject.retrieve
      expect(subject.retrieve[0]).to be_instance_of(TestMiddleware)
      expect(subject.retrieve[1]).to be_instance_of(TestMiddleware2)
      expect(subject.retrieve[2]).to be_instance_of(TestMiddleware3)
    end

  end

  describe "#exists?" do
    it "returns true when an entry exists" do
      subject.add(TestMiddleware, "hello")
      expect(subject.exists?(TestMiddleware)).to be(true)
    end

    it "returns false when an entry does not exist" do
      expect(subject.exists?(TestMiddleware)).to be(false)
    end
  end

  describe "#invoke" do

    let(:event) { double('event') }
    let(:channel_proxy) { double('channel_proxy') }

    it "yields control to the handler block" do
      expect { |b| subject.invoke(event, channel_proxy, &b) }.to yield_with_args(event, channel_proxy)
    end

  end

end
