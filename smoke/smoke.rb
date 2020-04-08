# Smoke testing for this gem

require 'tmpdir'
require 'pathname'

exe_path = File.expand_path('../exe/rubocop-extension-generator', __dir__)
load_path = File.expand_path('../lib', __dir__)

Dir.mktmpdir('-rubocop-extension-generator-smoke') do |base_dir|
  base_dir = Pathname(base_dir)
  gem_name = 'rubocop-smoke'
  gem_namespace = gem_name.sub('-', '/')
  gem_dir = base_dir / gem_name

  system({ 'RUBYLIB' => load_path }, 'ruby', exe_path, gem_name, exception: true, chdir: base_dir)

  gemspec_path = gem_dir / "#{gem_name}.gemspec"
  gemspec = gemspec_path.read
  gemspec[/spec\.summary.+/] = 'spec.summary = "a gem for smoke testing"'
  gemspec.gsub!(/^.+spec\.description.+$/, '')
  gemspec.gsub!(/^.+spec\.homepage.+$/, '')
  gemspec.gsub!(/^.+spec\.metadata.+$/, '')

  gemspec_path.write gemspec

  spec = gem_dir / "spec/#{gem_namespace}_spec.rb"
  specfile = spec.read
  specfile.gsub!('expect(false).to eq(true)', 'expect(true).to eq(true)')

  spec.write specfile

  system('bundle', 'install', exception: true, chdir: gem_dir)
  system('bundle', 'exec', 'rake', 'new_cop[Smoke/Foo]', exception: true, chdir: gem_dir)
  system('bundle', 'exec', 'rspec', exception: true, chdir: gem_dir)
end
