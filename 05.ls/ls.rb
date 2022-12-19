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
  'socket' => 's'
}.freeze

FILE_PERMISSION_TO_CHAR = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  options = load_options
  files = load_files(options)

  options[:l] ? display_files_in_long_format(files) : display_files_in_short_format(files)
end

def load_options
  opt = OptionParser.new

  options = {}

  opt.on('-a', 'do not ignore entries starting with .') { |v| options[:a] = v }
  opt.on('-r', 'reverse order while sorting .') { |v| options[:r] = v }
  opt.on('-l', 'use a long listing format') { |v| options[:l] = v }
  opt.parse!(ARGV)

  options
end

def load_files(options)
  all_files = Dir.entries('.').sort

  filtered_files =
    if options[:a]
      all_files
    else
      all_files.grep_v(/^\./)
    end

    options[:r] ? filtered_files.reverse : filtered_files
end

def build_file_info(files)
  files.map do |file|
    file_name = file.to_s
    file_lstat = File.lstat(file)
    file_mode = file_lstat.mode

    {
      file_type: FILE_TYPE_TO_CHAR[file_lstat.ftype],

      user_name: Etc.getpwuid(file_lstat.uid).name,
      group_name: Etc.getgrgid(file_lstat.gid).name,

      block_size: file_lstat.blocks,
      hardlink_count: file_lstat.nlink,
      time_stamp: file_lstat.mtime.strftime('%b %e %H:%M'),
      file_size: file_lstat.size,
      file_name: file_name,

      file_permission: concat_file_permission(file_mode)
    }
  end
end

def concat_file_permission(file_mode)
  file_0o_mode = file_mode.to_s(8)

  (-3..-1).map { |i| FILE_PERMISSION_TO_CHAR[file_0o_mode[i]] }.join
end

def display_files_in_long_format(files)
  file_info_list = build_file_info(files)

  total_block = file_info_list.map{ |information| information[:block_size] / 2 }.sum
  max_byte_length = file_info_list.map { |information| information[:file_size] }.max.to_s.length

  puts "total #{total_block}"

  file_info_list.each do |information|
    print information[:file_type]
    print information[:file_permission]
    print " #{information[:hardlink_count]}"
    print " #{information[:user_name]}"
    print " #{information[:group_name]}"
    print " #{information[:file_size].to_s.rjust(max_byte_length)}"
    print " #{information[:time_stamp]}"
    print " #{information[:file_name]}"
    print " -> #{File.readlink(information[:file_name])}" if File.symlink?(information[:file_name])
    puts
  end
end

def build_file_table(files)
  line_length = (files.size.to_f / COLUMN_LENGTH).ceil

  adding_nil_count = line_length * COLUMN_LENGTH - files.size
  files += Array.new(adding_nil_count)

  files.each_slice(line_length).to_a.transpose
end

def display_files_in_short_format(files)
  file_table = build_file_table(files)
  max_filename_length = files.max_by(&:length).length

  file_table.each do |files|
    files.each do |file|
      print file.ljust(max_filename_length + 1) if file
    end
    print "\n"
  end
end

main
