# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

require 'apidae/version'

Gem::Specification.new do |s|
  s.name          = "apidae"
  s.version       = Apidae::VERSION
  s.authors       = ["lacravate"]
  s.email         = ["lacravate@lacravate.fr"]
  s.homepage      = "https://github.com//apidae"
  s.summary       = "A gem to expose a file system through a Sinatra application"
  s.description   = "A gem to give a basis to create applications that expose a filesystem contents through a Sinatra application"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency "sinatra"
  s.add_development_dependency "rspec"
  s.add_development_dependency 'rack-test'
end
