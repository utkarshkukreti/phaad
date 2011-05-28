require 'spec_helper'

describe Phaad::Generator, 'array' do
  context "linear arrays" do
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

  context "associative arrays" do
    it "should create blank array" do
      compile("{}").should == "array();"
    end

    it "should create simple arrays" do
      compile("{a => :b, 1 => 2, /foo/ => /bar/}").should ==
        'array($a => "b", 1 => 2, "/foo/" => "/bar/");'
    end

    it "should create nested arrays" do
      compile("{1 => {2 => {3 => {4 => {5 => 6}}}}}").should ==
        "array(1 => array(2 => array(3 => array(4 => array(5 => 6)))));"
    end
  end

  it "should parse a mix of linear and associative arrays" do
    compile("[{}, [], {foo => [1, 2, 3, {}]}]").should ==
      "array(array(), array(), array($foo => array(1, 2, 3, array())));"
  end
end
