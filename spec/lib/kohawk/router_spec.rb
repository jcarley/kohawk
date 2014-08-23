require 'spec_helper'

describe Kohawk::Router do

  subject { Kohawk::Router.new }

  describe "public methods" do
    it { should respond_to(:exchanges) }
    it { should respond_to(:queues) }
    it { should respond_to(:subscribers) }
    it { should respond_to(:clear!) }
    it { should respond_to(:draw) }
    it { should respond_to(:eval_block) }
    it { should respond_to(:add_exchange) }
    it { should respond_to(:add_queue) }
  end

  describe "#clear!" do

    before(:each) do
      subject.draw do
        topic("test_exchange", :durable => true) do
          queue 'app:event:handler1'
          queue 'app:event:handler2'
        end
      end
    end

    it "clears the exchanges collection" do
      subject.clear!
      expect(subject.exchanges).to be_empty
    end

    it "clears the queues collection" do
      subject.clear!
      expect(subject.queues).to be_empty
    end
  end

  describe "#draw" do

    it "clears the route set" do
      expect(subject).to receive(:clear!).once
      subject.draw {}
    end

    it "yields to a given block" do
      expect { |b| subject.draw(&b) }.to yield_control
    end

    context "exchange" do

      it "adds a new exchange" do
        subject.draw do
          exchange "test_exchange"
        end
        expect(subject.exchanges).to include("test_exchange")
      end

      it "adds an exchange with the give options" do
        subject.draw do
          exchange "test_exchange", :type => :topic, :options => {:durable => true}
        end
        expect(subject.exchanges["test_exchange"]).to eql({:type => :topic, :options => {:durable => true}})
      end

      it "adds a topic exchange" do
        subject.draw do
          topic "test_exchange", :options => {:durable => true}
        end
        expect(subject.exchanges["test_exchange"]).to eql({:type => :topic, :options => {:durable => true}})
      end

    end

    context "queues" do

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

      it "uses the name param when no :as key is given" do
        subject.draw do
          queue 'app:event:handler'
        end
        expect(subject.queues).to include('app:event:handler')
      end

      it "adds a queue to the default exchange definition" do
        subject.draw do
          queue 'app:event:handler', :as => :test_event
        end
        expect(subject.queues[:test_event]).to include(:exchange => {:name => 'default', :type => :topic})
      end

      it "names the queue specified by the :as key" do
        subject.draw do
          queue 'app:event:handler', :as => :test_event
        end
        expect(subject.queues).to include(:test_event)
      end

      it "includes the name in the queue definition" do
        subject.draw do
          queue 'app:event:handler', :as => :test_event
        end
        expect(subject.queues[:test_event]).to include(:name => 'app:event:handler')
      end

      it "does not include the :as key in the queue definition" do
        subject.draw do
          queue 'app:event:handler', :as => :test_event
        end
        expect(subject.queues[:test_event]).to_not include(:as => :test_event)
      end

      it "adds the bindings to the queue definition" do
        subject.draw do
          queue 'app:event:handler', :bindings => ['app.person.create'], :as => :test_event
        end
        expect(subject.queues[:test_event]).to include(:bindings => ['app.person.create'])
      end

      it "adds options to the queue definition" do
        subject.draw do
          queue 'app:event:handler', :bindings => ['app.person.create'], :options => {:durable => true, :auto_delete => true}, :as => :test_event
        end
        expect(subject.queues[:test_event]).to include(:options => {:durable => true, :auto_delete => true})
      end

    end

    context "subscriber" do

      it "adds a subscriber" do
        subject.draw do
          queue 'app:person:added', :as => :person_added
          subscribe queue: :person_added, handler: 'person#added'
        end
        expect(subject.subscribers).to include(:person_added)
      end

      it "throws an error when adding a subscriber to a non-existant queue" do
        expect {
          subject.draw do
            queue 'app:person:added', :as => :person_added
            subscribe queue: :person, handler: 'person#added'
          end
        }.to raise_error(Kohawk::Router::NonExistentQueueError)
      end

      it "parses the handler mapping into class and method" do
        subject.draw do
          queue 'app:person:added', :as => :person_added
          subscribe queue: :person_added, handler: 'person#added'
        end
        expect(subject.subscribers[:person_added]).to include([PersonHandler, :added])
      end

      it "raises an error when a handler subscribes to a queue more than once" do
        expect {
          subject.draw do
            queue 'app:person:added', :as => :person_added
            subscribe queue: :person_added, handler: 'person#added'
            subscribe queue: :person_added, handler: 'person#added'
          end
        }.to raise_error(Kohawk::Router::DuplicateHandlerSubscriptionError)
      end

      it "requires a queue" do
        expect {
          subject.draw do
            queue 'app:person:added', :as => :person_added
            subscribe handler: 'person#added'
          end
        }.to raise_error(Kohawk::Router::QueueRequiredForSubscriptionError)
      end

      it "requires a handler" do
        expect {
          subject.draw do
            queue 'app:person:added', :as => :person_added
            subscribe queue: :person_added
          end
        }.to raise_error(Kohawk::Router::HandlerRequiredForSubscriptionError)
      end

      it "allows one subscription per queue" do
        expect {
          subject.draw do
            queue 'app:person:added', :as => :person_added
            subscribe queue: :person_added, handler: 'person#added'
            subscribe queue: :person_added, handler: 'asset#added'
          end
        }.to raise_error(Kohawk::Router::DuplicateSubscriptionError)
      end

    end

  end

end

# topic 'app_exchange' do
  # queue 'app:person:create', :bindings => ['app.person.create'], :as => :person_create
  # queue 'app:person:update', :bindings => ['app.person.update'], :as => :person_update
# end

# subscribe queue: 'person:create', handler: 'person#create'
# subscribe queue: 'person:update', handler: 'person#update'

# publish queue: 'app:events'



