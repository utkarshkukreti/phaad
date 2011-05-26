describe Phaad::Generator, 'assign' do
  it "should assign simple variables" do
    compile_statement("a = 1").should == "$a = 1"
    compile_statement('a = "foo"').should == '$a = "foo"'
    compile_statement("a = /foo/").should == '$a = "/foo/"'
  end
end
