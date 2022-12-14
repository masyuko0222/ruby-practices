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
  files   = load_files

  if options[:l]
    file_lstats = convert_files_to_lstats(files)
    total_block = sum_all_block_size(file_lstats)

    puts "total #{total_block}"

    max_byte_length = file_lstats.max_by(&:size).size.to_s.length

    file_lstats.size.times do |i|
      file_lstat = file_lstats[i]
      file_name  = files[i]

      file_lstat_informations = create_lstat_informations_hash(file_lstat)

      display_file_information(file_lstat_informations, max_byte_length, file_name)
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

def convert_files_to_lstats(files)
  files.map { |file| File.lstat(file) }
end

def sum_all_block_size(file_lstats)
  file_lstats.sum do |lstat|
    # blocksメソッドは1024バイトを1ブロックとして扱うが、lsコマンドでは512バイトで1ブロックのため、2で割る
    lstat.blocks / 2
  end
end

def create_lstat_informations_hash(file_lstat)
  file_mode = file_lstat.mode

  file_type       = FILE_TYPE_TO_CHAR[file_lstat.ftype]
  file_permission = concat_file_permission(file_mode)
  hardlink_count  = file_lstat.nlink
  user_name       = Etc.getpwuid(file_lstat.uid).name
  group_name      = Etc.getgrgid(file_lstat.gid).name
  file_size       = file_lstat.size
  time_stamp      = file_lstat.mtime.strftime('%b %e %H:%M')

  {
    file_type: file_type,
    file_permission: file_permission,
    hardlink_count: hardlink_count,
    user_name: user_name,
    group_name: group_name,
    file_size: file_size,
    time_stamp: time_stamp,
  }
end

def concat_file_permission(file_mode)
  file_0o_mode = file_mode.to_s(8)

  (-3..-1).map { |i| FILE_PERMISSION_TO_CHAR[file_0o_mode[i]] }.join
end

def display_file_information(file_lstat_informations, max_byte_length, file_name)
  print file_lstat_informations[:file_type]
  print file_lstat_informations[:file_permission]
  print " #{file_lstat_informations[:hardlink_count]}"
  print " #{file_lstat_informations[:user_name]}"
  print " #{file_lstat_informations[:group_name]}"
  print " #{file_lstat_informations[:file_size].to_s.rjust(max_byte_length)}"
  print " #{file_lstat_informations[:time_stamp]}"
  print " #{file_name}"
  print " -> #{File.readlink(file_name)}" if File.symlink?(file_name)
  puts
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
