module CustomCopsGenerator
  class CLI
    BANNER = <<~TEXT
      Usage: custom_cops_generator NAME
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

    private def to_dirname(name)
      name.sub('-', '/')
    end

    private def to_classname
      
    end
  end
end
