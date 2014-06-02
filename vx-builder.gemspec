# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vx/builder/version'

Gem::Specification.new do |spec|
  spec.name          = "vx-builder"
  spec.version       = Vx::Builder::VERSION
  spec.authors       = ["Dmitry Galinsky"]
  spec.email         = ["dima.exe@gmail.com"]
  spec.description   = %q{ Write a gem description}
  spec.summary       = %q{ Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'vx-common', '0.3.2'
  spec.add_runtime_dependency 'vx-message'
  spec.add_runtime_dependency 'hashr'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '2.14.1'
  spec.add_development_dependency "rr"
end
