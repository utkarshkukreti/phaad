require 'spec_helper'

describe Phaad::Generator, 'string' do
  context "string interpolation" do
    it "should parse simple interpolation" do
      compile('"a #{b}"').should == '"a " . $b;'
      compile('"a #{b c}"').should == '"a " . b($c);'
    end

    it "should parse complex interpolation" do
      compile('"a #{b} #{foo("bar", :baz)} "').should ==
        '"a " . $b . " " . foo("bar", "baz") . " ";'
    end

    it "should handle empty \#{} properly" do
      compile('"a #{b} #{} "').should == '"a " . $b . " " . " ";'
    end
  end
end

