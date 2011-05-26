require 'spec_helper'

describe Phaad::Generator, "binary" do
  it "should parse +, -, *, /, %" do
    compile_statement("1 + 2").should == "1 + 2"
    compile_statement("1 - 2").should == "1 - 2"
    compile_statement("1 * 2").should == "1 * 2"
    compile_statement("1 / 2").should == "1 / 2"
    compile_statement("1 % 2").should == "1 % 2"
  end

  it "should parse | & ^" do
    compile_statement("1 | 2").should == "1 | 2"
    compile_statement("1 & 2").should == "1 & 2"
    compile_statement("1 ^ 2").should == "1 ^ 2"
  end

  it "should parse ** to pow" do
    compile_statement("1 ** 2").should == "pow(1, 2)"
  end

  it "should parse && ||" do
    compile_statement("true && false").should == "TRUE && FALSE"
    compile_statement("true || false").should == "TRUE || FALSE"
  end

  it "should parse chain of binary statements" do
    compile_statement("1 + 2 - 3 + 4").should == "1 + 2 - 3 + 4"
    compile_statement("1 + 2 ** 3 ** 4").should == "1 + pow(2, pow(3, 4))"
  end
end
