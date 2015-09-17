#!/usr/bin/env gem build

require File.expand_path '../lib/mongoid_cleaner/version', __FILE__

Gem::Specification.new 'mongoid_cleaner', MongoidCleaner::VERSION do |spec|
  spec.author           = 'TD Dashboys'
  spec.email            = 'dashboys@td-berlin.com'
  spec.summary          = 'MongoidCleaner with drop and truncation strategy'
  spec.homepage         = 'https://github.com/td-berlin/mongoid_cleaner'
  spec.license          = 'MIT'
  spec.files            = Dir['{lib,test}/**/*', 'LICENSE.txt', 'README.md']
  spec.extra_rdoc_files = ['LICENSE.txt', 'README.md']

  spec.required_ruby_version     = '~> 2.1'
  spec.required_rubygems_version = '~> 2.4'

  spec.add_runtime_dependency 'mongoid', '~> 5.0.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.31'
end
