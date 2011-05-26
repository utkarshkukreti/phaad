require 'spec_helper' 

describe Phaad::Generator, "Literals" do
  it "should parse integers" do
    compile("1").should == "1"
  end

  it "should parse floats" do
    compile("1.0").should == "1.0"
  end

  it "should parse strings" do
    compile('"foo bar"').should == '"foo bar"'
    compile("'foo bar'").should == '"foo bar"'
    compile('"foo\nbar"').should == '"foo\nbar"'
  end

  it "should parse regexes" do
    compile("/ab/").should == '"/ab/"'
    compile("/ab/i").should == '"/ab/i"'
    compile('/a\b/i').should == '"/a\\b/i"'
  end

  it "should parse booleans" do
    compile("true").should == "TRUE"
    compile("false").should == "FALSE"
  end

  it "should parse nil" do
    compile("nil").should == "NULL"
  end

  it "should parse symbols as strings" do
    compile(":foo").should == '"foo"'
    compile(':"foo"').should == '"foo"'
  end
end
