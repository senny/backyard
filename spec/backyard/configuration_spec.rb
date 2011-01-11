require 'spec_helper'

describe Backyard::Configuration do

  subject { Backyard::Configuration.new }

  describe "#name_attribute" do
    context "with single for key" do
      it "should store the specified attribtues" do
        subject.name_attribute :username, :for => :string
        subject.config_for(String).name_attributes.should == [:username]
      end
    end

    context "for multiple models" do
      it "should store the specified attribtues" do
        subject.name_attribute :title, :for => [:string, :array, :hash]
        subject.config_for(Hash).name_attributes.should == [:title]
        subject.config_for(Array).name_attributes.should == [:title]
        subject.config_for(String).name_attributes.should == [:title]
      end
    end
  end

  describe "#name_for" do

    context "with a single model" do
      it "should store the block in the model config" do
        my_block = lambda {|name| }
        subject.name_for :array, &my_block
        subject.config_for(Array).name_blocks.should include(my_block)
      end
    end

    context "for multiple models" do
      it "should store the block in the model config" do
        my_block = lambda {|name| }
        subject.name_for :array, :hash, &my_block
        subject.config_for(Array).name_blocks.should include(my_block)
        subject.config_for(Hash).name_blocks.should include(my_block)
      end
    end
  end

  describe "#use_adapter" do
    it "should set the specified adapter" do
      subject.use_adapter :factory_girl
      subject.adapter_instance.should be_kind_of(Backyard::Adapter::FactoryGirl)
    end
  end

  describe "#adapter_instance" do
    describe "default: " do
      it "should return the factory girl adapter" do
        subject.adapter_instance.should be_kind_of(Backyard::Adapter::FactoryGirl)
      end
    end
  end

end
