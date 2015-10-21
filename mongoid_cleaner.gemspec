# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_cleaner/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid_cleaner'
  spec.version       = MongoidCleaner::VERSION
  spec.authors       = ['TD Dashboys']
  spec.email         = ['dashboys@td-berlin.com']

  spec.summary       = 'MongoidCleaner with drop and truncation strategy'
  spec.homepage      = 'https://github.com/td-berlin/mongoid_cleaner'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.31'
  spec.add_dependency 'mongoid', '>= 4.0'
end
