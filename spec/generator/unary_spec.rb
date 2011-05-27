describe Phaad::Generator, 'Unary' do
  it "should parse +" do
    compile("+a").should == "+$a;"
  end
  it "should parse -" do
    compile("-a").should == "-$a;"
  end
  it "should parse ~" do
    compile("~a").should == "~$a;"
  end
  it "should parse !" do
    compile("!a").should == "!$a;"
  end
end
