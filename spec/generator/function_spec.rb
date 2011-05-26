require 'spec_helper' 

describe Phaad::Generator, 'call a function' do
  it "should parse various function calls" do
    compile_statement("f()").should == "f()"
    compile_statement("f a").should == "f($a)"
    compile_statement("f(a)").should == "f($a)"
    compile_statement("f g a").should == "f(g($a))"
    compile_statement("f g(a)").should == "f(g($a))"
    compile_statement("a b c d, e, f()").should == "a(b(c($d, $e, f())))"
  end
end

describe Phaad::Generator, 'define a function' do
  it "should define a function without params" do
    compile_statement("def f\nend").should start_with("function f()")
  end

  it "should define a function with basic params" do
    compile_statement("def f a\nend").should start_with("function f($a)")
    compile_statement("def f(a)\nend").should start_with("function f($a)")
    compile_statement("def f a, b\nend").should start_with("function f($a, $b)")
    compile_statement("def f(a, b)\nend").should start_with("function f($a, $b)")
  end

  it "should define a function with params with default values" do
    compile_statement("def f a = 4\nend").should start_with("function f($a = 4)")
    compile_statement("def f a, b = 4\nend").should start_with("function f($a, $b = 4)")
  end
end
