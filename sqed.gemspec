# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sqed/version'

Gem::Specification.new do |spec|
  spec.name        = "sqed"
  spec.version     = Sqed::VERSION
  spec.authors     = ["Matt Yoder", "Rich Flood"]
  spec.email       = ["diapriid@gmail.com"]
  spec.summary     = %q{Specimens Quickly Extracted and Digitized, or just "squid". A ruby gem for image related specimen accessioning.}
  spec.description = %q{A utility gem to aid in the processing of images taken in the process of digitizing natural history collections.}
  spec.homepage    = "http://github.com/SpeciesFileGroup/sqed"
  spec.license     = "NCSA"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rake', '~> 11.1.2'
  spec.add_dependency 'rmagick', '~> 2.16'  
  spec.add_dependency 'rtesseract', '~> 2.1.0'

  # A qrcode reader, too many problems with compiling, dependencies
  # spec.add_dependency 'zxing_cpp', '~> 0.1.0'

  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'bundler', '~> 1.5'
  # spec.add_development_dependency 'did_you_mean', '~> 0.9'
  spec.add_development_dependency 'byebug', '~> 9.0.6'
  spec.add_development_dependency 'awesome_print', '~> 1.8'
end

