# frozen_string_literal: true

require 'optparse'

COLUMN_LENGTH = 3

def main
  files = load_files(load_options)

  max_filename_length = files.max_by(&:length).length
  file_table = build_file_table(files)

  display_files(file_table, max_filename_length)
end

def display_files(file_table, filename_length)
  file_table.each do |files|
    files.each do |file|
      print file.ljust(filename_length + 1) if file
    end
    print "\n"
  end
end

def load_options
  opt = OptionParser.new

  options = {}

  opt.on('-a', 'do not ignore entries starting with .') { |v| options[:a] = v }
  opt.parse!(ARGV)

  options
end

def load_files(options)
  if options[:a]
    Dir.entries('.').sort
  else
    Dir.entries('.').sort.grep_v(/^\./)
  end
end

def build_file_table(files)
  line_length = (files.size.to_f / COLUMN_LENGTH).ceil

  adding_nil_count = line_length * COLUMN_LENGTH - files.size
  files += Array.new(adding_nil_count)

  files.each_slice(line_length).to_a.transpose
end

main
