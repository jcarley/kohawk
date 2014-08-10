require 'spec_helper'

describe Kohawk::ConnectionManager do

  subject { Kohawk::ConnectionManager.instance }

  let(:options) do
    {
      :host  => "localhost",
      :vhost => "local",
      :port  => 5672,
      :user  => "dev",
      :pass  => "dev"
    }
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

    it "returns an instance of Bunny::Session" do
      expect(subject.connect(options)).to be_instance_of(Bunny::Session)
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
      expect(subject.session).to be_nil
    end
  end

end
