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

    context "with another factory provider than factory_girl" do
      class TestClass; end
      class TestClassFactory
        def self.build_class
          TestClass
        end
      end
      let(:factory_provider) do
        Class.new do
          def self.factories
            {:my_factory => TestClassFactory}
          end
        end
      end
      it "should use the factory class returned by #factory_girl_class" do
        subject.stub(:factory_girl_class) { factory_provider }
        subject.class_for_type(:my_factory).should == TestClass
      end
    end
  end

  describe "#factory_girl_class" do
    let(:factory_class) { Class.new }

    it "returns ::FactoryGirl for factory_girl 2.x and higher" do
      Object.const_set("FactoryGirl", factory_class)
      subject.send(:factory_girl_class).should == factory_class
      Object.send(:remove_const, "FactoryGirl")
    end

    it "returns Factory for factory_girl 1.x and lower" do
      subject.send(:factory_girl_class).should == Factory
    end
  end

end
