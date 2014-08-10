require 'spec_helper'

describe Kohawk::Configuration do

  describe "public methods" do

    it { should respond_to(:host) }
    it { should respond_to(:vhost) }
    it { should respond_to(:port) }
    it { should respond_to(:user) }
    it { should respond_to(:password) }
    it { should respond_to(:exchange_name) }
    it { should respond_to(:connect_options) }

  end

  it "returns the default middleware" do
    expect(Kohawk.configuration.middleware).to be_instance_of(Kohawk::Middleware::Chain)
  end

  it "yields the middleware chain when a block is given" do
    expect{ |b| Kohawk.configuration.middleware(&b) }.to yield_control
  end

end
