# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dancan/version'

Gem::Specification.new do |gem|
  gem.name          = "dancan"
  gem.version       = Dancan::VERSION
  gem.authors       = ["Daniel K"]
  gem.email         = ["dank@example.com"]
  gem.description   = %q{Object oriented authorization for Rails applications}
  gem.summary       = %q{OO authorization for Rails}
  gem.homepage      = "https://github.com/2011dkang1/dancan"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport", ">= 3.0.0"
  gem.add_development_dependency "activemodel", ">= 3.0.0"
  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "pry"   
end
