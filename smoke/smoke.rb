# Smoke testing for this gem

require 'tmpdir'
require 'pathname'
require 'open3'
require 'json'

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

  system('bundle', 'install', exception: true, chdir: gem_dir)
  system('bundle', 'exec', 'rake', 'new_cop[Smoke/Foo]', exception: true, chdir: gem_dir)

  stdout, status = Open3.capture2(
    { 'SPEC_OPTS' => '--format json' },
    *['bundle', 'exec', 'rake', 'spec'],
    chdir: gem_dir,
  )
  stdout_json = stdout.lines.find { |l| l.start_with?('{') }
  failures = JSON.parse(stdout_json)['examples'].select { |example| example['status'] == 'failed' }

  unexpected_failures = failures.map { |failure| failure['full_description'] } - [
    'RuboCop::Smoke has a version number',
    'RuboCop::Smoke does something useful',
    'RuboCop::Cop::Smoke::Foo registers an offense when using `#bad_method`',
  ]
  if !unexpected_failures.empty?
    raise "rspec failed. Unknown failures:\n#{unexpected_failures.join("\n")}"
  end
end
