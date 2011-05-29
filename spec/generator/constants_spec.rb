require 'spec_helper'

describe Phaad::Generator, 'constants' do
  it "should allow referring to constants" do
    compile("FOO").should == "FOO;"
  end
end
