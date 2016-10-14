# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deep_store/version'

Gem::Specification.new do |spec|
  spec.name          = 'deep_store'
  spec.version       = DeepStore::VERSION
  spec.authors       = ['Marcelo Wiermann']
  spec.email         = ['marcelo.wiermann@gmail.com']

  spec.summary       = 'AWS S3 ODM'
  spec.description   = 'AWS S3 ODM'
  spec.homepage      = 'https://github.com/marcelow/deep_store'
  spec.license       = 'MIT'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.add_runtime_dependency 'aws-sdk'
  spec.add_runtime_dependency 'activemodel'
  spec.add_runtime_dependency 'mime-types'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'dotenv'
end
