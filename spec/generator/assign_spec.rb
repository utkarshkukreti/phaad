describe Phaad::Generator, 'assign' do
  it "should assign simple variables" do
    compile("a = 1").should == "$a = 1;"
    compile('a = "foo"').should == '$a = "foo";'
    compile("a = /foo/").should == '$a = "/foo/";'
  end
end
