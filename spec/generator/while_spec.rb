require 'spec_helper'

describe Phaad::Generator, "while" do
  it "should parse while statements" do
    compile("while a\nb\nend").should == "while($a) {\n  $b;\n}"
  end

  it "should parse one line while statements" do
    compile("b while a").should == "while($a) {\n  $b;\n}"
  end

  it "should parse until statements" do
    compile("until a\nb\nend").should == "while(!($a)) {\n  $b;\n}"
    compile("until a + b\nc\nend").should == "while(!($a + $b)) {\n  $c;\n}"
  end

  it "should parse one line until statements" do
    compile("b until a").should == "while(!($a)) {\n  $b;\n}"
  end
end
