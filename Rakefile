#!/usr/bin/env rake

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks.'
end

# === Bundler ===

Bundler::GemHelper.install_tasks

# === Tests ===

require 'rake/testtask'

Rake::TestTask.new do |config|
  config.libs << 'test'
  config.test_files = FileList['test/test*.rb']
  config.verbose = true
end

# === Configuration ===

# Run all tests as default task.
task default: :test
