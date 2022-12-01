# frozen_string_literal: true

require 'optparse'

COLUMN_LENGTH = 3

def main
  loaded_files = load_files(add_option)

  max_filename_length = loaded_files.max_by(&:length).length
  file_table = build_file_table(loaded_files)

  file_table.each do |files|
    files.each do |file|
      print file.ljust(max_filename_length + 1) if file
    end
    print "\n"
  end
end

def add_option
  opt = OptionParser.new

  params = {}

  opt.on('-a', 'do not ignore entries starting with .') { |v| params[:a] = v }
  opt.parse!(ARGV)

  params
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
