# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rankmatic/version'

Gem::Specification.new do |spec|
  spec.name          = "rankmatic"
  spec.version       = Rankmatic::VERSION
  spec.authors       = ["David Elliott"]
  spec.email         = ["david.elliott@stitchfix.com"]

  spec.summary       = %q{Ranks CSV rows}
  spec.description   = %q{A CSV describing submissions reviewed by multiple people is ranked for highest average}
  spec.homepage      = "http://hadto.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug", "~> 3.4.2"

  spec.add_runtime_dependency "thor", "0.19.4"
end
