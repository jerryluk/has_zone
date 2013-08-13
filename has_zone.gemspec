# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_zone/version'

Gem::Specification.new do |spec|
  spec.name          = "has_zone"
  spec.version       = HasZone::VERSION
  spec.authors       = ["Jerry Luk"]
  spec.email         = ["jerryluk@gmail.com"]
  spec.description   = %q{Provides a way to convert from TZinfo time zone identifer to ActiveSupport TimeZone for your Rails application.}
  spec.summary       = %q{Provides a way to convert from TZinfo time zone identifer to ActiveSupport TimeZone for your Rails application.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4.0"
  spec.add_dependency "activemodel", ">= 4.0"
  spec.add_dependency "tzinfo"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
