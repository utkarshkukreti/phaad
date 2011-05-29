require 'spec_helper'

describe Phaad::Generator, 'assign' do
  it "should assign simple variables" do
    compile("a = 1").should == "$a = 1;"
    compile('a = "foo"').should == '$a = "foo";'
    compile("a = /foo/").should == '$a = "/foo/";'
  end

  it "should assign array fields" do
    compile("a[] = 1").should == "$a[] = 1;"
    compile("a[0] = 1").should == "$a[0] = 1;"
    compile("a['foo'] = 1").should == '$a["foo"] = 1;'
  end
end
