# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_LENGTH = 3
FILE_TYPE_TO_CHAR = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's',
}.freeze
FILE_PERMISSION_TO_CHAR = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx',
}.freeze

def main
  options = load_options
  files = load_files

  if options[:l]
    files.each do |file|
      file_lstat = File.lstat(file)
      file_mode = file_lstat.mode

      display_file_option_l(file, file_mode)
    end
  else
    file_table = build_file_table(files)
    max_filename_length = files.max_by(&:length).length

    display_files_no_option(file_table, max_filename_length)
  end
end

def load_options
  opt = OptionParser.new

  options = {}

  opt.on('-l', 'use a long listing format') { |v| options[:l] = v }
  opt.parse!(ARGV)

  options
end

def load_files
  Dir.entries('.').sort.grep_v(/^\./)
end

def display_file_option_l(file, file_mode)
  file_type = load_file_type(file)
  file_permission = concat_file_permission(file_mode)
  user_name = convert_uid_to_name(file)
  group_name = convert_gid_to_name(file)

  print file_type
  print file_permission
  print " #{user_name}"
  print " #{group_name}"
  puts
end

def load_file_type(file)
  FILE_TYPE_TO_CHAR[File.ftype(file)]
end

def concat_file_permission(file_mode)
  file_0o_mode = file_mode.to_s(8)

  (-3..-1).map { |i| FILE_PERMISSION_TO_CHAR[file_0o_mode[i]] }.join
end

def convert_uid_to_name(file)
  Etc.getpwuid(file.uid).name
end

def convert_gid_to_name(file)
  Etc.getgrgid(file.gid).name
end

def build_file_table(files)
  line_length = (files.size.to_f / COLUMN_LENGTH).ceil

  adding_nil_count = line_length * COLUMN_LENGTH - files.size
  files += Array.new(adding_nil_count)

  files.each_slice(line_length).to_a.transpose
end

def display_files_no_option(file_table, filename_length)
  file_table.each do |files|
    files.each do |file|
      print file.ljust(filename_length + 1) if file
    end
    print "\n"
  end
end


main
