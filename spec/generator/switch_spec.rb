require 'spec_helper'

describe Phaad::Generator, "switch" do
  it "should parse case statements" do
    compile("case a\nwhen b\nc\nend").should == "switch($a) {\n  case $b:\n    $c;\n    break;\n}"
  end

  it "should parse multiple when statements" do
    compile("case a\nwhen b\nc\nwhen d\ne\nend").should ==
      "switch($a) {\n  case $b:\n    $c;\n    break;\n  case $d:\n    $e;\n    break;\n}"
  end

  it "should parse else statement" do
    compile("case a\nwhen b\nc\nwhen d\ne\nelse\nf\nend").should ==
      "switch($a) {\n  case $b:\n    $c;\n    break;\n  case $d:\n    $e;\n    break;\n" +
      "  default:\n    $f;\n    break;\n}"
  end

  it "should parse multiple case in single when statement" do
    compile("case a\nwhen b, c, d\ne\nend").should ==
      "switch($a) {\n  case $b: case $c: case $d:\n    $e;\n    break;\n}"
  end
end
