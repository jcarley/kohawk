require 'spec_helper'

describe Kohawk::ConnectionManager do

  it "only creates one instance of ConnectionManager" do
    instance1 = Kohawk::ConnectionManager.instance
    instance2 = Kohawk::ConnectionManager.instance

    expect(instance1).to be(instance2)
  end



end
