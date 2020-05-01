# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'realms/version'

Gem::Specification.new do |spec|
  spec.name          = "realms"
  spec.version       = Realms::VERSION
  spec.authors       = ["Tony Schneider"]
  spec.email         = ["tonywok@gmail.com"]

  spec.summary       = %q{a star realms implementation}
  spec.description   = %q{building a card game for the first time}
  spec.homepage      = "https://bitbucket.org/tonywok/realms"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "activesupport", "~> 6.0.0"
  spec.add_dependency "brainguy"
  spec.add_dependency "equalizer"
end
