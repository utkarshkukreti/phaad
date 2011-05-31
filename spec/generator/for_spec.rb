require 'spec_helper'

describe Phaad::Generator, "for" do
  context "over linear or associative arrays" do
    it "should parse one variable for statements" do
      compile("for a in b\nend").should == "foreach($b as $a) {\n}"
    end

    it "should parse two variable for statements" do
      compile("for a, b in c\nend").should == "foreach($c as $a => $b) {\n}"
    end

    it "should parse the body" do
      compile("for a, b in c\na\nb\nend").should == "foreach($c as $a => $b) {\n  $a;\n  $b;\n}"
    end
  end
end
