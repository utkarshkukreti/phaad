require 'spec_helper'

describe Phaad::Generator, 'ternary' do
  it "should parse simple ternary operations" do
    compile("a ? b : c").should == "$a ? $b : $c;"
  end
end
