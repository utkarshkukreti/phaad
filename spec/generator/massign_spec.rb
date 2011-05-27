describe Phaad::Generator, 'massign' do
  it "should multi-assign variables" do
    compile("a, b = 1, 2").should == "$a = 1;\n$b = 2;"
    compile('a, b = "foo", /foo/').should == "$a = \"foo\";\n$b = \"/foo/\";"
    compile("a, b, c = 1, 2, 3").should == "$a = 1;\n$b = 2;\n$c = 3;"
    compile("a, b, c, d = 1, 2, 3, 4").should == "$a = 1;\n$b = 2;\n$c = 3;\n$d = 4;"
    compile("a, b, c, d, e, f, g, h, i, j = 1, 1, 2, 3, 5, 8, 13, 21, 34, 55").should ==
      "$a = 1;\n$b = 1;\n$c = 2;\n$d = 3;\n$e = 5;\n$f = 8;\n$g = 13;\n$h = 21;\n" +
      "$i = 34;\n$j = 55;"
  end
end
