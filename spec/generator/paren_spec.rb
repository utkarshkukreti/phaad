require 'spec_helper'

describe Phaad::Generator, 'paren' do
  it "should parse statements with parentheses" do
    compile("(1)").should == "(1);"
    compile("a + (b c)").should == "$a + (b($c));"
    compile("a * (b + c * (d + e))").should == "$a * ($b + $c * ($d + $e));"
  end
end
