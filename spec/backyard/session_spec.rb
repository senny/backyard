require 'spec_helper'

describe Backyard::Session do

  let(:adapter) { mock }

  subject do
    sessionClass = Class.new do
      include Backyard::Session
    end
    session = sessionClass.new
    session.stub(:adapter => adapter)
    session
  end

  describe "#get_model" do
    it "should delegate to the model_store" do
      model_store = mock
      subject.stub(:model_store => model_store)
      adapter.should_receive(:class_for_type).with(:user).and_return(Struct)
      model_store.should_receive(:get).with(Struct, 'Jeremy').and_return('I am Jeremy')
      subject.get_model(:user, 'Jeremy').should == 'I am Jeremy'
    end
  end

  describe "#get_models" do
    before do
      adapter.should_receive(:class_for_type).with(:array).and_return(Array)
    end
    context "when no models are stored" do
      it "should return an empty array" do
        subject.get_models(:array).should be_empty
      end
    end
  end

  describe "#put_model" do
    context "with a name" do
      context "with an attributes Hash" do
        it "should delegate to the model_store" do
          model_store = mock
          subject.stub(:model_store => model_store)
          adapter.should_receive(:create).with(:post, {}).and_return('The Post')
          adapter.should_receive(:class_for_type).with(:post).and_return(String)

          model_store.should_receive(:put).with('First Post!', 'The Post')
          subject.put_model(:post, 'First Post!')
        end
      end
    end

    context "without a name" do
      it "should generate a name" do
        adapter.should_receive(:create).with(:note, {}).and_return('The Note')
        adapter.should_receive(:class_for_type).with(:note).twice.and_return(String)
        Backyard::Session.should_receive(:generate_model_name).with(:note).and_return { 'Note 123' }

        subject.put_model(:note)
        subject.get_model(:note, 'Note 123').should == 'The Note'
      end
    end

    context "with an object" do
      it "should store the object under the given name" do
        subject.put_model({:me => 'Johhny'}, 'Johnny')
        subject.get_model(Hash, 'Johnny').should == {:me => 'Johhny'}
      end
    end
  end

  describe "#model_exists?" do
    context "the model is present" do
      it "should return true" do
        subject.should_receive(:get_model).with(:user, 'James').and_return('This is James')
        subject.model_exists?(:user, 'James').should be_true
      end
    end

    context "the model does not exist" do
      it "should return false" do
        subject.should_receive(:get_model).with(:user, 'James').and_return(nil)
        subject.model_exists?(:user, 'James').should be_false
      end
    end
  end

  describe "#model" do
    context "the model with the given name exists" do
      it "should return the existing model" do
        subject.should_receive(:get_model).with(:note, 'welcome').twice.and_return('Hallo')
        subject.model(:note, 'welcome').should == 'Hallo'
      end
    end

    context "no model exists for the given name" do
      it "should create a new model" do
        subject.should_receive(:get_model).with(:note, 'see you').and_return(nil)
        subject.should_receive(:put_model).with(:note, 'see you', {}).and_return('The Note')
        subject.model(:note, 'see you').should == 'The Note'
      end
    end
  end

  describe ".generate_model_name" do
    it "should use the capitalized name as starting point" do
      Backyard::Session.generate_model_name(:user).should be_start_with('User ')
    end

    it "should always generate a unique name" do
      (1..10).map { Backyard::Session.generate_model_name(:article) }.uniq.should have(10).items
    end
  end
end
