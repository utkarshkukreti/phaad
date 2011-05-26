require 'spec_helper'

describe Phaad::Generator, 'paren' do
  it "should parse statements with parentheses" do
    compile_statement("(1)").should == "(1)"
    compile_statement("a + (b c)").should == "$a + (b($c))"
    compile_statement("a * (b + c * (d + e))").should == "$a * ($b + $c * ($d + $e))"
  end
end
