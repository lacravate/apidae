# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'apidae/version'

Gem::Specification.new do |s|
  s.name          = "apidae"
  s.version       = Apidae::VERSION
  s.authors       = ["lacravate"]
  s.email         = ["lacravate@lacravate.fr"]
  s.homepage      = "https://github.com//apidae"
  s.summary       = "TODO: summary"
  s.description   = "TODO: description"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
end
