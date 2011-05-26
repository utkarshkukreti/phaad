require 'spec_helper'

describe Phaad::Generator, "if" do
  it "should parse if statements" do
    compile_statement("if a\nb\nend").should == "if($a) {\n$b;\n}\n"
    compile_statement("if a\nb\nc\nend").should == "if($a) {\n$b;\n$c;\n}\n"
  end

  it "should parse if else statements" do
    compile_statement("if a\nb\nelse\nc\nend").should == "if($a) {\n$b;\n} else {\n$c;\n}\n"
  end

  it "should parse if elsif statements" do
    compile_statement("if a\nb\nelsif c\nd\nend").should == "if($a) {\n$b;\n} elseif($c) {\n$d;\n}\n"
  end

  it "should parse if elsif else statements" do
    compile_statement("if a\nb\nelsif c\nd\nelse\n e\nend").should == 
      "if($a) {\n$b;\n} elseif($c) {\n$d;\n} else {\n$e;\n}\n"
  end

  it "should parse if then end statements" do
    compile_statement("if a then b end").should == "if($a) {\n$b;\n}\n"
  end

  it "should parse if then else end statements" do
    compile_statement("if a then b else c end").should == "if($a) {\n$b;\n} else {\n$c;\n}\n"
  end

  it "should parse if then elsif else end statements" do
    compile_statement("if a then b elsif c then d else e end").should == 
      "if($a) {\n$b;\n} elseif($c) {\n$d;\n} else {\n$e;\n}\n"
  end
end
