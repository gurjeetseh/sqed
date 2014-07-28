# encoding: UTF-8

recent_ruby = RUBY_VERSION >= '2.1.1'
raise "IMPORTANT: sqed gem requires ruby >= 2.1.1" unless recent_ruby

require "rmagick"
require_relative "sqed/version"
require_relative "sqed/quadrant_parser"
require_relative "sqed/ocr_parser"
require_relative "sqed/barcode_parser"

module Sqed

  DEFAULT_TMP_DIR = "/tmp"

end
