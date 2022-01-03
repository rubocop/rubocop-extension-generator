module RuboCop
  module Extension
    module Generator
      class Generator
        def initialize(name)
          @name = name
        end

        def generate
          system('bundle', 'gem', name, exception: true)

          put "lib/#{name}.rb", <<~RUBY
            # frozen_string_literal: true

            require 'rubocop'

            require_relative '#{dirname}'
            require_relative '#{dirname}/version'
            require_relative '#{dirname}/inject'

            RuboCop::#{classname}::Inject.defaults!

            require_relative '#{cops_file_name.sub(/\.rb$/, '').sub(/^lib\//, '')}'
          RUBY

          put "lib/#{dirname}/inject.rb", <<~RUBY
            # frozen_string_literal: true

            # The original code is from https://github.com/rubocop/rubocop-rspec/blob/master/lib/rubocop/rspec/inject.rb
            # See https://github.com/rubocop/rubocop-rspec/blob/master/MIT-LICENSE.md
            module RuboCop
              module #{classname}
                # Because RuboCop doesn't yet support plugins, we have to monkey patch in a
                # bit of our configuration.
                module Inject
                  def self.defaults!
                    path = CONFIG_DEFAULT.to_s
                    hash = ConfigLoader.send(:load_yaml_configuration, path)
                    config = Config.new(hash, path).tap(&:make_excludes_absolute)
                    puts "configuration from \#{path}" if ConfigLoader.debug?
                    config = ConfigLoader.merge_with_default(config, path)
                    ConfigLoader.instance_variable_set(:@default_configuration, config)
                  end
                end
              end
            end
          RUBY

          put cops_file_name, <<~RUBY
            # frozen_string_literal: true
          RUBY

          put "config/default.yml", <<~YAML
            # Write it!
          YAML

          put 'spec/spec_helper.rb', <<~RUBY
            # frozen_string_literal: true

            require '#{name}'
            require 'rubocop/rspec/support'

            RSpec.configure do |config|
              config.include RuboCop::RSpec::ExpectOffense

              config.disable_monkey_patching!
              config.raise_errors_for_deprecations!
              config.raise_on_warning = true
              config.fail_if_no_examples = true

              config.order = :random
              Kernel.srand config.seed
            end
          RUBY

          put '.rspec', <<~TEXT
            --format documentation
            --color
            --require spec_helper
          TEXT

          put '.rubocop.yml', <<~YML
            Naming/FileName:
             Exclude:
               - lib/#{name}.rb
          YML

          patch "lib/#{dirname}.rb", /^  end\nend/, <<~RUBY
                PROJECT_ROOT   = Pathname.new(__dir__).parent.parent.expand_path.freeze
                CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze
                CONFIG         = YAML.safe_load(CONFIG_DEFAULT.read).freeze

                private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
              end
            end
          RUBY

          patch "lib/#{dirname}.rb", 'module Rubocop', 'module RuboCop'
          patch "lib/#{dirname}/version.rb", 'module Rubocop', 'module RuboCop'
          patch "#{name}.gemspec", 'Rubocop', 'RuboCop'

          patch "#{name}.gemspec", /^end/, <<~RUBY

              spec.add_runtime_dependency 'rubocop'
            end
          RUBY

          patch "Rakefile", /\z/, <<~RUBY

            require 'rspec/core/rake_task'

            RSpec::Core::RakeTask.new(:spec) do |spec|
              spec.pattern = FileList['spec/**/*_spec.rb']
            end

            desc 'Generate a new cop with a template'
            task :new_cop, [:cop] do |_task, args|
              require 'rubocop'

              cop_name = args.fetch(:cop) do
                warn 'usage: bundle exec rake new_cop[Department/Name]'
                exit!
              end

              generator = RuboCop::Cop::Generator.new(cop_name)

              generator.write_source
              generator.write_spec
              generator.inject_require(root_file_path: '#{cops_file_name}')
              generator.inject_config(config_file_path: 'config/default.yml')

              puts generator.todo
            end
          RUBY

          patch 'Gemfile', /\z/, <<~RUBY
            gem 'rspec'
          RUBY

          patch 'README.md', /^gem '#{name}'$/, "gem '#{name}', require: false"

          puts
          puts <<~MESSAGE
            It's done! You can start developing a new extension of RuboCop in #{root_path}.
            For the next step, you can use the cop generator.

              $ bundle exec rake 'new_cop[#{classname}/SuperCoolCopName]'
          MESSAGE
        end

        private def put(path, content)
          path = root_path / path
          puts "create #{path}"
          FileUtils.mkdir_p(path.dirname) unless path.dirname.directory?
          path.write(content)
        end

        private def patch(path, pattern, replacement)
          puts "update #{path}"
          path = root_path / path
          file = path.read
          raise "Cannot apply patch for #{path} because #{pattern} is missing" unless file.match?(pattern)
          path.write file.sub(pattern, replacement)
        end

        private def root_path
          @root_path ||= Pathname(name)
        end

        private def dirname
          @dirname ||= name.sub('-', '/')
        end

        private def classname
          @classname ||= name.split('-').last.camelcase
        end

        private def cops_file_name
          @cops_file_name ||= "lib/rubocop/cop/#{name.split('-').last}_cops.rb"
        end

        attr_reader :name
        private :name
      end
    end
  end
end
