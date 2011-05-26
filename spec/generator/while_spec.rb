require 'spec_helper'

describe Phaad::Generator, "while" do
  it "should parse while statements" do
    compile_statement("while a\nb\nend").should == "while($a) {\n$b;\n}\n"
  end

  it "should parse one line while statements" do
    compile_statement("b while a").should == "while($a) {\n$b;\n}\n"
  end

  it "should parse until statements" do
    compile_statement("until a\nb\nend").should == "while(!$a) {\n$b;\n}\n"
  end

  it "should parse one line until statements" do
    compile_statement("b until a").should == "while(!$a) {\n$b;\n}\n"
  end
end
