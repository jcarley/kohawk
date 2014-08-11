require 'spec_helper'

describe Kohawk::ConnectionManager do

  subject { Kohawk::ConnectionManager.instance }

  let(:adapter) { double('adapter', :connect => nil, :disconnect => nil) }

  let(:options) do
    {
      :host  => "localhost",
      :vhost => "local",
      :port  => 5672,
      :user  => "dev",
      :pass  => "dev"
    }
  end

  before(:each) do
    Kohawk.configuration.adapter = adapter
  end

  after(:each) do
    subject.disconnect
    Kohawk.configuration.adapter = nil
  end

  it "only creates one instance of ConnectionManager" do
    instance1 = Kohawk::ConnectionManager.instance
    instance2 = Kohawk::ConnectionManager.instance

    expect(instance1).to be(instance2)
  end

  describe "public methods" do
    it { should respond_to(:connect).with(1).arguments }
    it { should respond_to(:disconnect).with(0).arguments }
  end

  describe "#connect" do

    it "returns an instance of an adaptor" do
      expect(subject.connect(options)).to be(adapter)
    end

    it "returns the same connection" do
      connection1 = subject.connect(options)
      connection2 = subject.connect(options)
      expect(connection1).to be(connection2)
    end

  end

  describe "#disconnect" do

    it "closes the session" do
      subject.connect(options)
      subject.disconnect
      expect(subject.adapter).to be_nil
    end
  end

end
