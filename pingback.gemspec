# -*- encoding: utf-8 -*-
require File.expand_path("../lib/pingback/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pingback"
  s.version     = Pingback::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Andreas Wurm']
  s.email       = ['andreaswurm@gmx.de']
  s.homepage    = "https://github.com/AndreasWurm/pingback"
  s.summary     = "This library enables the user to write pingback aware applications."
  s.description = "This library enables the user to write pingback aware applications."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'nokogiri'
  s.add_dependency 'rack'
  s.add_dependency 'xmlrpc'
  
  s.add_development_dependency "rake", "10.4.2"
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 2.5.0"
  s.add_development_dependency "webmock", ">= 1.6.2"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "pretty-xml", "0.1.1"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
