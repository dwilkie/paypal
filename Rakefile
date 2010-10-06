require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the Paypal plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'spec'
  t.libs << 'features'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "paypal-ipn"
    gemspec.summary = "Another ruby wrapper for Paypal"
    gemspec.email = "dwilkie@gmail.com"
    gemspec.homepage = "http://github.com/dwilkie/paypal"
    gemspec.authors = ["David Wilkie"]
    gemspec.add_runtime_dependency "httparty", ">=0.6.1"
    gemspec.add_runtime_dependency "rack"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

desc 'Generate documentation for the Paypal plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Paypal'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

