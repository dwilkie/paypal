# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "paypal/version"

Gem::Specification.new do |s|
  s.name        = "paypal-ipn"
  s.version     = Paypal::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Wilkie"]
  s.email       = ["dwilkie@gmail.com"]
  s.homepage    = "https://github.com/dwilkie/paypal"
  s.summary     = %q{More than just IPNs}
  s.description = %q{A ruby library for handling paypal api's including IPNs}
  s.add_runtime_dependency("httparty")

  s.rubyforge_project = "paypal"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

