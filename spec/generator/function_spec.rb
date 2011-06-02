require 'spec_helper' 

describe Phaad::Generator, 'call a function' do
  it "should parse various function calls" do
    compile("f()").should == "f();"
    compile("f a").should == "f($a);"
    compile("f(a)").should == "f($a);"
    compile("f g a").should == "f(g($a));"
    compile("f g(a)").should == "f(g($a));"
    compile("a b c d, e, f()").should == "a(b(c($d, $e, f())));"
  end

  it "should not add brackets when calling global, echo, var" do
    compile("echo a").should == "echo $a;"
    compile("echo a, b").should == "echo $a, $b;"
    compile("global a").should == "global $a;"
    compile("global a, b").should == "global $a, $b;"
    compile("var a").should == "var $a;"
    compile("var a, b").should == "var $a, $b;"
  end

  it "should print new ClassName when ClassName.new is called" do
    compile("Foo.new").should == "new Foo;"
    compile("Foo.new a, b, c").should == "new Foo($a, $b, $c);"
    compile("Foo.new(a, b, c)").should == "new Foo($a, $b, $c);"
  end

  it "should call using :: when a function is called on a Constant" do
    compile("Foo.bar()").should == "Foo::bar();"
    compile("Foo.bar a, b, c").should == "Foo::bar($a, $b, $c);"
    compile("Foo.bar(a, b, c)").should == "Foo::bar($a, $b, $c);"
  end
end

describe Phaad::Generator, 'define a function' do
  context "normal function" do
    it "should define a function without params" do
      compile("def f\nend").should start_with("function f()")
    end

    it "should define a function with basic params" do
      compile("def f a\nend").should start_with("function f($a)")
      compile("def f(a)\nend").should start_with("function f($a)")
      compile("def f a, b\nend").should start_with("function f($a, $b)")
      compile("def f(a, b)\nend").should start_with("function f($a, $b)")
    end

    it "should define a function with params with default values" do
      compile("def f a = 4\nend").should start_with("function f($a = 4)")
      compile("def f a, b = 4\nend").should start_with("function f($a, $b = 4)")
    end
  end

  context "static (self) function" do
    it "should define a function with/without params" do
      compile("def self.f\nend").should start_with("static function f()")
      compile("def self.f(a, b)\nend").should start_with("static function f($a, $b)")
    end
  end
end
