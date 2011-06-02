require 'spec_helper'

describe Phaad::Generator, 'keywords' do
  it "should compile break" do
    compile("break").should == "break;"
  end

  it "should compile next into continue" do
    compile("next").should == "continue;"
  end
end
