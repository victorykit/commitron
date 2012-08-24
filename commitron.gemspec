# -*- encoding: utf-8 -*-
require File.expand_path('../lib/commitron/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michelle D'Souza"]
  gem.email         = ["michd2005@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "commitron"
  gem.require_paths = ["lib"]
  gem.version       = Commitron::VERSION

  gem.add_dependency "skypemac"
  gem.add_dependency "daemons"
  gem.add_dependency "libnotify"
  gem.add_dependency "github_api"
  gem.add_dependency "time-lord"
  gem.add_dependency "selenium-webdriver"
  gem.add_development_dependency "rspec", "> 2.0.0"
end
