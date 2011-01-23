require 'spec_helper'

describe Backyard::Session do

  let(:model_store) { mock }
  let(:adapter) { mock }

  subject do
    sessionClass = Class.new do
      include Backyard::Session
    end
    session = sessionClass.new
    session.stub(:adapter => adapter)
    session.stub(:model_store => model_store)
    session
  end

  describe "#get_model" do

    it "should delegate to the model_store" do
      adapter.should_receive(:class_for_type).with(:user).and_return(Struct)
      model_store.should_receive(:get).with(Struct, 'Jeremy').and_return('I am Jeremy')
      subject.get_model(:user, 'Jeremy').should == 'I am Jeremy'
    end

    context "with a reloadable model" do
      it "should return the reloaded model" do
        object = Array.new
        object.should_receive(:reload).and_return(['I', 'am', 'reloaded'])

        adapter.should_receive(:class_for_type).with(:array).and_return(Array)
        model_store.should_receive(:get).with(Array, 'Reloadable Array').and_return(object)

        subject.get_model(:array, 'Reloadable Array').should == ['I', 'am', 'reloaded']
      end
    end

  end

  describe "#get_models" do

    it "should delegate to the model_store" do
      adapter.should_receive(:class_for_type).with(:array).and_return(Array)
      model_store.should_receive(:get_collection).with(Array).and_return([[1], [2]])
      subject.get_models(:array).should == [[1], [2]]
    end
  end

  describe "#put_model" do
    context "with a name" do
      context "with an attributes Hash" do
        it "should delegate to the model_store" do
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
        adapter.should_receive(:class_for_type).with(:note).and_return(String)
        adapter.should_receive(:generate_model_name).with(:note).and_return { 'Note 123' }
        model_store.should_receive(:put).with('Note 123', 'The Note')

        subject.put_model(:note)
      end
    end

    context "with an object" do
      it "should store the object under the given name" do
        model_store.should_receive(:put).with('Johnny', {:me => 'Johhny'})
        subject.put_model({:me => 'Johhny'}, 'Johnny')
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

end
