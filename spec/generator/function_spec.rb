require 'spec_helper' 

describe Phaad::Generator, 'function' do
  it "should parse 'f()'" do
    compile_statement("f()").should == "f()"
    compile_statement("f a").should == "f($a)"
    compile_statement("f(a)").should == "f($a)"
    compile_statement("f g a").should == "f(g($a))"
    compile_statement("f g(a)").should == "f(g($a))"
    compile_statement("a b c d, e, f()").should == "a(b(c($d, $e, f())))"
  end
end
