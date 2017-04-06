# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gdatastore_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = "gdatastore_mapper"
  spec.version       = GdatastoreMapper::VERSION
  spec.authors       = ["Shinya Kitamura"]
  spec.email         = ["shinya.kitamura.14@gmail.com"]

  spec.summary       = %q{Google Cloud Datastore Mapper in Ruby / Ruby on Rails}
  spec.description   = %q{Google Cloud Datastore ORM/ODM (Mapper) in Ruby and Ruby on Rails}
  spec.homepage      = "https://github.com/shinyaK14/gdatastore_mapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency 'google-cloud', '~> 0.27'
end
