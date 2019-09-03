require "custom_cops_generator/version"
require "custom_cops_generator/cli"
require "custom_cops_generator/generator"

require 'active_support'
require 'active_support/core_ext/string/inflections'

require 'optparse'
require 'pathname'
require 'fileutils'

module CustomCopsGenerator
  class Error < StandardError; end
  # Your code goes here...
end
