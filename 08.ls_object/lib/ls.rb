# frozen_string_literal: true

require 'optparse'
require_relative './directory'
require_relative './ls_long_format'
require_relative './ls_short_format'

def main
  args = load_args

  file_names = Directory.new(**args.slice(:all_files, :reverse_in_sort)).load_file_names

  formatted_file_names =
    args[:long_format] ? LsLongFormat.new(file_names).format : LsShortFormat.new(file_names).format

  puts formatted_file_names
end

def load_args
  opt = OptionParser.new

  args = { all_files: false, reverse_in_sort: false, long_format: false }

  opt.on('-a', 'do not ignore entries starting with .') { |v| args[:all_files] = v }
  opt.on('-r', 'reverse order while sorting') { |v| args[:reverse_in_sort] = v }
  opt.on('-l', 'use a long listing format') { |v| args[:long_format] = v }
  opt.parse!(ARGV)

  args
end

main

