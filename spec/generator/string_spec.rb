require 'spec_helper'

describe Phaad::Generator, 'string' do
  context "escaping" do
    it "should parse double quotes" do
      compile(%q{'"'}).should == %q{"\"";}
      compile(%q{'\"'}).should == %q{"\\\"";}
      compile(%q{'\\"'}).should == %q{"\\\"";}
    end

    ##
    # Ripper parses single quotes the same as double quotes. There's no way to
    # know if a single quote was used or a double quote was.
    # it "should respect escape sequences in single and double quotes" do
    #   compile(%q{"\n"}).should == %q{"\\n";}
    #   compile(%q{'\n'}).should == %q{"\\\\n";}
    # end
  end
  context "string interpolation" do
    it "should parse simple interpolation" do
      compile('"a #{b}"').should == '"a " . $b;'
      compile('"a #{b c}"').should == '"a " . b($c);'
    end

    it "should parse complex interpolation" do
      compile('"a #{b} #{foo("bar", :baz)} "').should ==
        '"a " . $b . " " . foo("bar", "baz") . " ";'
    end

    it "should handle empty \#{} properly" do
      compile('"a #{b} #{} "').should == '"a " . $b . " " . " ";'
    end
  end
end

