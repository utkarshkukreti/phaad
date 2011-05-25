require 'spec_helper'

describe Phaad do
  it "should have a version" do
    Phaad::VERSION.should be_a(String)
  end
end
