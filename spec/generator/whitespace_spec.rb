require 'spec_helper'

describe Phaad::Generator, "Whitespace" do
  it "should correctly parse this huge program" do
    input = <<EOT
def complex_hello_world(name = "Foo Bar", greeting = "Howdy")
  print_greeting greeting
  print_name name
  echo "Howdy is cooler!" if greeting != "Howdy"
  echo "Impossible" unless 1 == 1
end

def print_name(name)
  if name == "Foo Bar"
    i = 0
    while i < 10
      echo "Your name is not 'Foo Bar'"
      i = i + 1
    end
  elsif name == "1337"
    echo "l33t" while true
  else
    echo name
  end
end

def print_greeting(greeting)
  if greeting == "Howdy"
    complex_hello_world "Foo Bar", "Bug"
    echo greeting until true
  else
    echo greeting
  end
end

complex_hello_world "Utkarsh"
EOT

  expected_output = <<EOT
function complex_hello_world($name = "Foo Bar", $greeting = "Howdy") {
  print_greeting($greeting);
  print_name($name);
  if($greeting != "Howdy") {
    echo("Howdy is cooler!");
  }
  if(!(1 == 1)) {
    echo("Impossible");
  }
}
function print_name($name) {
  if($name == "Foo Bar") {
    $i = 0;
    while($i < 10) {
      echo("Your name is not 'Foo Bar'");
      $i = $i + 1;
    }
  } elseif($name == "1337") {
    while(TRUE) {
      echo("l33t");
    }
  } else {
    echo($name);
  }
}
function print_greeting($greeting) {
  if($greeting == "Howdy") {
    complex_hello_world("Foo Bar", "Bug");
    while(!(TRUE)) {
      echo($greeting);
    }
  } else {
    echo($greeting);
  }
}
complex_hello_world("Utkarsh");
EOT

    compile(input).should == expected_output.chomp
  end

  it "should parse this class program" do
input = <<EOT
class Foo
  def bar
    @came = 1
    return true
  end
end
EOT

expected_output = <<EOT
class Foo {
  function bar() {
    $this->came = 1;
    return TRUE;
  }
}
EOT
    compile(input).should == expected_output.chomp
  end
end
