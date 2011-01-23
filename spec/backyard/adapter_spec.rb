require 'spec_helper'

describe Backyard::Adapter do

  describe "#class_for_type" do
    it "should transform the type into a CamelCase Class" do
      subject.class_for_type(:user_session).should == 'UserSession'
    end
  end

  describe "#create" do
    it "should raise a NotImplementedError" do
      lambda do
        subject.create(:post, {})
      end.should raise_error(NotImplementedError)
    end
  end

  describe "#generate_model_name" do
    it "should use the capitalized name as starting point" do
      subject.generate_model_name(:user).should be_start_with('User ')
    end

    it "should always generate a unique name" do
      (1..10).map { subject.generate_model_name(:article) }.uniq.should have(10).items
    end
  end

end
