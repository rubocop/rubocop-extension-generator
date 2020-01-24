# Smoke testing for this gem

require 'tmpdir'
require 'pathname'

exe_path = File.expand_path('../exe/rubocop-extension-generator', __dir__)
load_path = File.expand_path('../lib', __dir__)

Dir.mktmpdir('-rubocop-extension-generator-smoke') do |base_dir|
  base_dir = Pathname(base_dir)
  gem_name = 'rubocop-smoke'
  gem_dir = base_dir / gem_name

  system({ 'RUBYLIB' => load_path }, 'ruby', exe_path, gem_name, exception: true, chdir: base_dir)

  gemspec_path = gem_dir / "#{gem_name}.gemspec"
  gemspec = gemspec_path.read
  gemspec[/spec\.summary.+/] = 'spec.summary = "a gem for smoke testing"'
  gemspec.gsub!(/^.+spec\.description.+$/, '')
  gemspec.gsub!(/^.+spec\.homepage.+$/, '')
  gemspec.gsub!(/^.+spec\.metadata.+$/, '')

  gemspec_path.write gemspec

  config_path = gem_dir / '.rubocop.yml'
  config_path.write config_path.read + <<~CONFIG
    require: rubocop-smoke

    Smoke/Foo:
      Enabled: true
  CONFIG

  system('bundle', 'install', exception: true, chdir: gem_dir)
  system('bundle', 'exec', 'rake', 'new_cop[Smoke/Foo]', exception: true, chdir: gem_dir)
  system('bundle', 'exec', 'rubocop', '--display-only-fail-level-offenses', '--fail-level', 'F', exception: true, chdir: gem_dir)
  system('bundle', 'exec', 'rake', 'spec', exception: true, chdir: gem_dir)
end
