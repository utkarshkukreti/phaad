require 'spec_helper'

describe Phaad::Generator, 'define a class' do
  it "should define a bare class" do
    compile("class A; end").should == "class A {\n}"
  end

  it "should define a class which inherits" do
    compile("class A < B; end").should == "class A extends B {\n}"
  end
end
