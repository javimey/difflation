# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'difflation/version'

Gem::Specification.new do |gem|
  gem.name          = "difflation"
  gem.version       = Difflation::VERSION
  gem.authors       = ["Javier Mey"]
  gem.email         = ["javier.mey@sage.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rspec-rails')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('pry')
end
