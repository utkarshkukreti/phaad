require 'spec_helper'

describe Phaad::Generator, 'array' do
  it "should create blank array" do
    compile("[]").should == "array();"
  end

  it "should create simple arrays" do
    compile("[1, 'a', /b/, true]").should == 'array(1, "a", "/b/", TRUE);'
  end

  it "should create nested arrays" do
    compile("[1, [1, [2, [3, [5, [8, 13]]]]]]").should == 
      "array(1, array(1, array(2, array(3, array(5, array(8, 13))))));"
  end
end
