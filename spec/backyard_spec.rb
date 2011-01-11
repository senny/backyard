require 'spec_helper'

describe Backyard do

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

end
