require 'spec_helper'

describe Backyard do

  describe "name_based_database_lookup" do
    before :each do
      Backyard.reset_name_based_database_lookup
    end

    it "default is set to false" do
      Backyard.name_based_database_lookup.should be_false
    end

    it "can be set to true" do
      Backyard.name_based_database_lookup = true

      Backyard.name_based_database_lookup.should be_true
    end

    it "can be reseted" do
      Backyard.name_based_database_lookup = true

      Backyard.reset_name_based_database_lookup

      Backyard.name_based_database_lookup.should be_false
    end
  end

  describe ".configure" do
    it "should eval the configuration block in the Backyard::Configuration scope" do
      scope = nil
      Backyard.configure do
        scope = self
      end
      scope.should be_kind_of(Backyard::Configuration)
    end
  end

  describe ".config" do
    it "should return a Backyard::Configuration" do
      Backyard.configure {}
      Backyard.config.should be_kind_of(Backyard::Configuration)
    end
  end

  describe ".global_store" do
    it "is a Backyard::Session" do
      Backyard.global_store.should be_kind_of(Backyard::Session)
    end

    it "is always the same object" do
      Backyard.global_store.should == Backyard.global_store
    end
  end

end
