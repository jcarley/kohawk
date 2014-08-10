require 'spec_helper'

describe Kohawk do

  describe "#configuration" do

    it "yields when a block is given" do
      expect { |b| Kohawk.configuration(&b) }.to yield_control
    end

    it "yields to Kohawk::Configuration" do
      expect { |b| Kohawk.configuration(&b) }.to yield_with_args(Kohawk::Configuration)
    end

  end

end
