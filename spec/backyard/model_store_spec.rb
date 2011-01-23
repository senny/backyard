require 'spec_helper'

describe Backyard::ModelStore do

  subject { Backyard::ModelStore.new }

  it "should store models" do
    subject.put "John", [:i, :am, :john]
    subject.get(Array, "John").should == [:i, :am, :john]
  end

  it "should store models with different types and the same name" do
    subject.put "Jane", "This is Jane"
    subject.put ["Jane"], %w(this is jane)
    subject.get(String, 'Jane').should == "This is Jane"
  end

  describe "#get_collection" do
    context "without models" do
      it "should return an emtpy array" do
        subject.get_collection(Hash).should == []
      end
    end

    context "with models" do
      before do
        subject.put "John", "I am John"
        subject.put "Jane", "I am Jane"
      end

      it "should return 2 items" do
        subject.get_collection(String).should have(2).items
      end


      it "should return the models" do
        subject.get_collection(String).should == {
          'John' =>'I am John',
          'Jane' => 'I am Jane'
        }
      end
    end
  end

end
