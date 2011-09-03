# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "phaad/version"

Gem::Specification.new do |s|
  s.name        = "phaad"
  s.version     = Phaad::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Utkarsh Kukreti"]
  s.email       = ["utkarshkukreti@gmail.com"]
  s.homepage    = "https://github.com/utkarshkukreti/phaad/"
  s.summary     = %q{A beautiful way to write PHP}
  s.description = %q{A beautiful way to write PHP}

  s.rubyforge_project = "phaad"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'slop', '~>1.6.0'
  s.add_dependency 'fssm', '~>0.2.7'
  s.add_development_dependency 'rspec', '~>2.6.0'
  s.add_development_dependency 'guard-rspec', '~>0.4.3'
end
