require 'spec_helper'

describe Phaad::Generator, 'constants' do
  it "should allow referring to constants" do
    compile("FOO").should == "FOO;"
  end

  # http://php.net/manual/en/language.constants.predefined.php
  context "magic constants" do
    it "should parse __LINE__" do
      compile("__LINE__").should == "__LINE__;"
    end

    it "should parse __FILE__" do
      compile("__FILE__").should == "__FILE__;"
    end

    it "should parse __DIR__" do
      compile("__DIR__").should == "__DIR__;"
    end

    it "should parse __FUNCTION__" do
      compile("__FUNCTION__").should == "__FUNCTION__;"
    end

    it "should parse __CLASS__" do
      compile("__CLASS__").should == "__CLASS__;"
    end

    it "should parse __METHOD__" do
      compile("__METHOD__").should == "__METHOD__;"
    end

    it "should parse __NAMESPACE__" do
      compile("__NAMESPACE__").should == "__NAMESPACE__;"
    end
  end

end
