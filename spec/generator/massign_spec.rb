describe Phaad::Generator, 'massign' do
  it "should multi-assign variables" do
    compile("a, b = 1, 2").should == "$a = 1;\n$b = 2;"
    compile('a, b = "foo", /foo/').should == "$a = \"foo\";\n$b = \"/foo/\";"
  end
end
