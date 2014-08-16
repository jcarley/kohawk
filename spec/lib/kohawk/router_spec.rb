require 'spec_helper'

describe Kohawk::Router do

  subject { Kohawk::Router.new }

  describe "public methods" do
    it { should respond_to(:clear!) }
    it { should respond_to(:draw) }
    it { should respond_to(:eval_block) }
  end

  describe "#draw" do

    it "clears the route set" do
      expect(subject).to receive(:clear!).once
      subject.draw {}
    end

    it "yields to a given block" do
      expect { |b| subject.draw(&b) }.to yield_control
    end

    it "adds a new exchange" do
      subject.draw do
        exchange "test_exchange"
      end
      expect(subject.exchanges).to include("test_exchange")
    end

    it "adds an exchange with the give options" do
      subject.draw do
        exchange "test_exchange", :type => :topic, :durable => true
      end
      expect(subject.exchanges["test_exchange"]).to eql({:type => :topic, :durable => true})
    end

    it "adds a topic exchange" do
      subject.draw do
        topic "test_exchange", :durable => true
      end
      expect(subject.exchanges["test_exchange"]).to eql({:type => :topic, :durable => true})
    end

    it "adds a new queue" do
      subject.draw do
        topic("test_exchange", :durable => true) do
          queue 'app:event:handler'
        end
      end
      expect(subject.queues).to include('app:event:handler')
    end

    it "adds a new queue to an exchange" do
      subject.draw do
        topic("test_exchange", :durable => true) do
          queue 'app:event:handler'
        end
      end
      expect(subject.queues['app:event:handler']).to include(:exchange => {:name => 'test_exchange', :type => :topic, :durable => true})
    end
  end

end
