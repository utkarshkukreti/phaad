require 'spec_helper' 

describe Phaad::Generator, "Literals" do
  it "should parse integers" do
    compile_statement("1").should == "1"
  end

  it "should parse floats" do
    compile_statement("1.0").should == "1.0"
  end

  it "should parse strings" do
    compile_statement('"foo bar"').should == '"foo bar"'
    compile_statement("'foo bar'").should == '"foo bar"'
    compile_statement('"foo\nbar"').should == '"foo\nbar"'
  end

  it "should parse regexes" do
    compile_statement("/ab/").should == '"/ab/"'
    compile_statement("/ab/i").should == '"/ab/i"'
    compile_statement('/a\b/i').should == '"/a\\b/i"'
  end

  it "should parse booleans" do
    compile_statement("true").should == "TRUE"
    compile_statement("false").should == "FALSE"
  end

  it "should parse nil" do
    compile_statement("nil").should == "NULL"
  end

  it "should parse symbols as strings" do
    compile_statement(":foo").should == '"foo"'
    compile_statement(':"foo"').should == '"foo"'
  end
end
