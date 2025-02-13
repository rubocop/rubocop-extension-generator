# frozen_string_literal: true

require "rubocop/extension/generator/version"
require "rubocop/extension/generator/cli"
require "rubocop/extension/generator/generator"

require 'active_support'
require 'active_support/core_ext/string/inflections'

require 'bundler'

require 'optparse'
require 'pathname'
require 'fileutils'

module RuboCop
  module Extension
    module Generator
    end
  end
end
