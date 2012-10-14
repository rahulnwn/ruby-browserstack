# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'browserstack/version'

Gem::Specification.new do |gem|
  gem.name          = "browserstack"
  gem.version       = Browserstack::VERSION
  gem.authors       = ["Rahul Nawani"]
  gem.email         = ["rahulnwn@gmail.com"]
  gem.description   = %q{Ruby gem for interacting with the Browserstack API}
  gem.summary       = %q{Ruby gem for interacting with the Browserstack API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency("rspec", "2.11.0")
  gem.add_development_dependency("webmock", "1.8.11")
  gem.add_dependency("yajl-ruby", "1.1.0")
end
