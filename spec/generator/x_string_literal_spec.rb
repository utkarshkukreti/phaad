require 'spec_helper'

describe Phaad::Generator, 'x_string_literal' do
  it "should parse `$a=2` in $a=2; " do
    compile("`$a=2`").should == "$a=2;"
  end
  
  it "should parse %x{ namespace \Test } in namespace \Test" do
    compile("%x{namespace \Test}").should == "namespace \Test;"
  end 
  
end
