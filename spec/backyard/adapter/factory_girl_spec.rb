require 'spec_helper'

describe Backyard::Adapter::FactoryGirl do

  describe "#create" do
    it "should delegate to factory_girl" do
      subject.should_receive(:Factory).with(:entry, {:name => '123 Entry'})
      subject.create :entry, {:name => '123 Entry'}
    end
  end

  describe "#class_for_type" do
    it "should work with a factory where the class is specified as text" do
      subject.class_for_type(:my_string_factory).should == String
    end

    it "should work with a factory where the class is specified as an Object" do
      subject.class_for_type(:my_hash_factory).should == Hash
    end

    it "should work with a factory where the class is guessed" do
      subject.class_for_type(:array).should == Array
    end

    context "when no factory is defined" do
      it "should raise an ArgumentError" do
        lambda do
          subject.class_for_type(:i_am_not_a_valid_factory)
        end.should raise_error(ArgumentError)
      end
    end
  end

end
