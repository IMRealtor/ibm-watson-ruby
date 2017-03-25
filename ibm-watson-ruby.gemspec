# -*- encoding: utf-8 -*-

require File.expand_path('../lib/ibm_watson/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "ibm-watson-ruby"
  gem.version       = IBMWatson::VERSION
  gem.summary       = "IBM Watson services in ruby"
  gem.description   = "."
  gem.license       = "MIT"
  gem.authors       = ["Bram Whillock"]
  gem.email         = "bramski@gmail.com"
  gem.homepage      = "https://github.com/imrealtor/watson-ruby"
  gem.required_ruby_version = '~> 2.3'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency "http", "~> 2.0"
  gem.add_dependency "active_attr", '~> 0.10'
  gem.add_dependency "active_attr_extended", "~> 0.9"

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'rspec-middlewares'
  gem.add_development_dependency 'vcr'
end
