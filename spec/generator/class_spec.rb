require 'spec_helper'

describe Phaad::Generator, 'class' do
  context 'define a class' do
    it "should define a bare class" do
      compile("class A; end").should == "class A {\n}"
    end

    it "should define a class which inherits" do
      compile("class A < B; end").should == "class A extends B {\n}"
    end
  end

  context 'access object variables' do
    it "should allow accessing a.b" do
      compile("a.b").should == "$a->b;"
    end

    it "should allow accessing a.b.c.d.e" do
      compile("a.b.c.d.e").should == "$a->b->c->d->e;"
    end
  end

  context "access object functions" do
    it "should allow calling a.b()" do
      compile("a.b()").should == "$a->b();"
    end

    it "should allow calling a.b c" do
      compile("a.b c").should == "$a->b($c);"
      compile("a.b(c)").should == "$a->b($c);"
    end

    it "should allow calling a.b c, d" do
      compile("a.b c, d").should == "$a->b($c, $d);"
      compile("a.b(c, d)").should == "$a->b($c, $d);"
    end
  end

  context "chained access" do
    it "mix of chained variable and function calls" do
      compile("a.b(c, d).e(f, g).h().i").should == "$a->b($c, $d)->e($f, $g)->h()->i;"
    end
  end
end
