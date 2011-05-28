# Phaad

Phaad is a little language, written in Ruby, implementing a subset of Ruby's syntax, and compiling it down to PHP.

## Status

Phaad is a work in progress. I made it to save myself from typing dollar signs, and brackets everywhere, when developing in PHP, while teaching myself a little about Lexers and Parsers.

The following features are currently implemented

- Unary operators ~, +, -, !
- Binary operators 
  - Arithmetic: +, -, \*, /, %, \*\* (converted to `pow`)
  - Logical: &&, ||, and, or
  - Bitwise: |, &, ^
  - Comparison: ==, !=, >, <, >=, <=, ===
  - Regex match: =~, !~ (converted to `preg_match`)
- Assigning variables, both single and multiple at once (`a, b = 1, 2` => `$a = 1;\n$b=2;`)  
- if, unless, while, and until statements, both in the long and one line form of Ruby
- Function definitions

## Getting Started

### Installing

It's best to install the latest revision from the repository.

    git clone https://github.com/utkarshkukreti/phaad.git
    cd phaad
    bundle install
    rake spec # optional
    rake install

Installing the gem will provide you with a `phaad` command. Invoking it without any parameters brings up an interactive REPL, similar to IRB. You can type in code, and get the generated PHP code back instantly.

## Examples

It's best to checkout the [spec](https://github.com/utkarshkukreti/phaad/tree/master/spec) directory for a list of features with examples for now.

## License

MIT License. (c) 2011 Utkarsh Kukreti.

