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

  context "over ranges" do
    it "should loop over a simple range" do
      compile("for a in 1..10\nend").should == "for($a = 1; $a <= 10; $a++) {\n}"
      compile("for a in 1...10\nend").should == "for($a = 1; $a < 10; $a++) {\n}"
    end

    it "should loop over a dynamic range" do
      compile("for a in 1..b\nend").should == "for($a = 1; $a <= $b; $a++) {\n}"
      compile("for a in 1...b\nend").should == "for($a = 1; $a < $b; $a++) {\n}"
      compile("for a in b..10\nend").should == "for($a = $b; $a <= 10; $a++) {\n}"
      compile("for a in b...10\nend").should == "for($a = $b; $a < 10; $a++) {\n}"
      compile("for a in b..c\nend").should == "for($a = $b; $a <= $c; $a++) {\n}"
      compile("for a in b...c\nend").should == "for($a = $b; $a < $c; $a++) {\n}"
    end

    it "should parse the body" do
      compile("for a in 1...10\na\nend").should == "for($a = 1; $a < 10; $a++) {\n  $a;\n}"
      compile("for a in b...c\na\nb\nc\nend").should ==
        "for($a = $b; $a < $c; $a++) {\n  $a;\n  $b;\n  $c;\n}"
    end
  end
end
