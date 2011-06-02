require 'spec_helper'

describe Phaad::Generator, "binary" do
  it "should parse +, -, *, /, %" do
    compile("1 + 2").should == "1 + 2;"
    compile("1 - 2").should == "1 - 2;"
    compile("1 * 2").should == "1 * 2;"
    compile("1 / 2").should == "1 / 2;"
    compile("1 % 2").should == "1 % 2;"
  end

  it "should parse | & ^" do
    compile("1 | 2").should == "1 | 2;"
    compile("1 & 2").should == "1 & 2;"
    compile("1 ^ 2").should == "1 ^ 2;"
  end

  it "should parse ** to pow" do
    compile("1 ** 2").should == "pow(1, 2);"
  end

  it "should parse && ||" do
    compile("true && false").should == "TRUE && FALSE;"
    compile("true || false").should == "TRUE || FALSE;"
  end

  it "should parse 'and' and 'or'" do
    compile("true and false").should == "TRUE && FALSE;"
    compile("true or false").should == "TRUE || FALSE;"
  end

  it "should parse chain of binary statements" do
    compile("1 + 2 - 3 + 4").should == "1 + 2 - 3 + 4;"
    compile("1 + 2 ** 3 ** 4").should == "1 + pow(2, pow(3, 4));"
  end

  it "should parse == != > < >= <= ===" do
    compile("1 == 2").should == "1 == 2;"
    compile("1 != 2").should == "1 != 2;"
    compile("1 > 2").should == "1 > 2;"
    compile("1 < 2").should == "1 < 2;"
    compile("1 >= 2").should == "1 >= 2;"
    compile("1 <= 2").should == "1 <= 2;"
    compile("1 === 2").should == "1 === 2;"
  end

  it "should parse =~ and !~ to preg_match statements" do
    compile("a =~ b").should == "preg_match($b, $a);"
    compile("a !~ b").should == "!preg_match($b, $a);"
  end

  it "should parse << as ." do
    compile("'foo' << 'bar'").should == '"foo" . "bar";'
  end

  context "operator assign" do
    it "should parse += -= *= /= %=" do
      compile("a += 1").should == "$a += 1;"
      compile("a -= 1").should == "$a -= 1;"
      compile("a *= 1").should == "$a *= 1;"
      compile("a /= 1").should == "$a /= 1;"
      compile("a %= 1").should == "$a %= 1;"
    end

    it "should parse |= &= ^=" do
      compile("a |= 1").should == "$a |= 1;"
      compile("a &= 1").should == "$a &= 1;"
      compile("a ^= 1").should == "$a ^= 1;"
    end

    it "should parse && ||" do
      compile("a &&= false").should == "$a &&= FALSE;"
      compile("a ||= false").should == "$a ||= FALSE;"
    end

    it "should parse <<= into .=" do
      compile("a <<= b").should == "$a .= $b;"
    end
  end
end
