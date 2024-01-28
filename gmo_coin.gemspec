# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gmo_coin/version"

Gem::Specification.new do |spec|
  spec.name          = "gmo_coin"
  spec.version       = GmoCoin::VERSION
  spec.authors       = ["akiraNuma"]
  spec.email         = ["akiran@akiranumakura.com"]

  spec.summary       = %q{API wrapper for GMO Coin.}
  spec.description   = %q{API wrapper for trading with GMO Coin.}
  spec.homepage      = "https://github.com/akiraNuma/gmo_coin"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.4'
  spec.add_dependency "activesupport"
  spec.add_dependency "rest-client"
  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
