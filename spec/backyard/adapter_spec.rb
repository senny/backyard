require 'spec_helper'

describe Backyard::Adapter do

  it "should raise a NotImplementedError when calling create" do
    lambda do
      subject.create(:post, {})
    end.should raise_error(NotImplementedError)
  end

end
