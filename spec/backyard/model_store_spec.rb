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

end
