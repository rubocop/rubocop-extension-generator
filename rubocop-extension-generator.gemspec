# frozen_string_literal: true

require_relative 'lib/rubocop/extension/generator/version'

Gem::Specification.new do |spec|
  spec.name          = "rubocop-extension-generator"
  spec.version       = RuboCop::Extension::Generator::VERSION
  spec.authors       = ["Masataka Pocke Kuwabara"]
  spec.email         = ["kuwabara@pocke.me"]

  spec.summary       = %q{A generator of RuboCop's custom cops gem}
  spec.description   = %q{A generator of RuboCop's custom cops gem}
  spec.homepage      = "https://github.com/rubocop/rubocop-extension-generator"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")
  spec.licenses = ['MIT']

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rubocop', '>= 1.72.2'
  spec.add_runtime_dependency 'bundler'
  spec.add_runtime_dependency 'activesupport'
end
