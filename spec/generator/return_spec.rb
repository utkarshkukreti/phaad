require 'spec_helper'

describe Phaad::Generator, 'return' do
  it "should parse return statements" do
    compile("return a").should == "return $a;"
    #TODO: allow return a, b -> return array($a, $b);
  end
end
