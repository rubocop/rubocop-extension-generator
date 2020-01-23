module RuboCop
  module Extension
    module Generator
      class CLI
        BANNER = <<~TEXT
          Usage: rubocop-extension-generator NAME

          The NAME must start with rubocop-, like rubocop-rspec.
        TEXT

        def self.run(argv)
          new(argv).run
        end

        def initialize(argv)
          @argv = argv
        end

        def run
          # For --help
          opt = OptionParser.new(BANNER)
          opt.version = VERSION
          args = opt.parse(@argv)

          name = args.first
          fail!(opt) unless name
          fail!(opt) unless name.match?(/\Arubocop-\w+\z/)

          Generator.new(name).generate
        end

        private def fail!(opt)
          puts opt.help
          exit 1
        end
      end
    end
  end
end
