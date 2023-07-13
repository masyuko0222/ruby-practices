# frozen_string_literal: true

require_relative './files_formatter'
require 'optparse'

def load_options
  opt = OptionParser.new

  options = { all_files: false, reverse_in_sort: false, long_format: false }

  opt.on('-a', 'do not ignore entries starting with .') { |v| options[:all_files] = v }
  opt.on('-r', 'reverse order while sorting') { |v| options[:reverse_in_sort] = v }
  opt.on('-l', 'use a long listing format') { |v| options[:long_format] = v }
  opt.parse!(ARGV)

  options
end

params = load_options

puts FilesFormatter.new(params).format
