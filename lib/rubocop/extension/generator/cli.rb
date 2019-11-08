module RuboCop
  module Extension
    module Generator
      class CLI
        BANNER = <<~TEXT
          Usage: rubocop-extension-generator NAME
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
          args = opt.parse(@argv)

          name = args.first
          raise "It must be named `rubocop-*`. For example: rubocop-rspec" unless name.match?(/\Arubocop-\w+\z/)

          Generator.new(name).generate
        end
      end
    end
  end
end
