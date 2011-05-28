require 'spec_helper'

describe Phaad::Generator, "instance variables" do
  it "should parse instance variable correctly" do
    compile("@a").should == "$this->a;"
    compile("@a = 1").should == "$this->a = 1;"
  end
end
