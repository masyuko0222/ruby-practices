# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_LENGTH = 3
FILE_TYPE_TO_CHAR = { '01' => 'p', '02' => 'c', '04' => 'd', '6' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
FILE_PERMISSION_TO_CHAR = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

def main
  options = load_options
  files = load_files

  if options.empty?
    file_table = build_file_table(files)
    max_filename_length = files.max_by(&:length).length

    display_files_no_option(file_table, max_filename_length)

  elsif options[:l]
    max_byte_length = load_max_byte_length(files)

    puts "total #{load_block_total(files)}"
    display_files_option_l(files, max_byte_length)
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

def load_file_lstat(file)
  File.lstat(file)
end

def load_max_byte_length(files)
  max_byte_file =
    files.max_by do |file|
      load_file_lstat(file).size
    end

  load_file_lstat(max_byte_file).size.to_s.length
end

def load_block_total(files)
  files.sum do |file|
    # blocksメソッドは1024バイトを1ブロックとして扱うが、lsコマンドでは512バイトで1ブロックのため、2で割る
    load_file_lstat(file).blocks / 2
  end
end

def display_files_option_l(files, max_byte_length)
  files.each do |file|
    file_modes = scan_file_modes(file)

    file_modes_string  = load_mode_to_file_type(file_modes) + load_mode_to_file_permission(file_modes)
    hardlink_count     = load_file_lstat(file).nlink.to_s
    user_name          = Etc.getpwuid(load_file_lstat(file).uid).name
    group_name         = Etc.getgrgid(load_file_lstat(file).gid).name
    file_size          = load_file_lstat(file).size
    time_stamp         = load_file_lstat(file).mtime.strftime('%b %e %H:%M')

    print "#{file_modes_string} "
    print "#{hardlink_count} "
    print "#{user_name} #{group_name} "
    print "#{file_size.to_s.rjust(max_byte_length)} "
    print "#{time_stamp} "
    print "#{file} "
    print "-> #{File.readlink(file.to_s)}" if File.symlink?(file.to_s)
    puts
  end
end

def scan_file_modes(file)
  file_mode_0o = load_file_lstat(file).mode.to_s(8)

  # directoryの場合は8進数表記だと5桁になってしまうため、6桁にしてからscanメソッドを使って2文字ずつに分割しました
  six_digit_mode = file_mode_0o.size < 6 ? "0#{file_mode_0o}" : file_mode_0o

  six_digit_mode.scan(/../)
end

def load_mode_to_file_type(file_modes)
  FILE_TYPE_TO_CHAR[file_modes[0]]
end

def load_mode_to_file_permission(file_modes)
  file_permissions = [file_modes[1], *file_modes[2].chars]

  # ornerの権限が1桁の値でも、先頭に0を加えた2桁表記になってしまうため、先頭の0を削除しました
  file_permissions[0].delete_prefix!('0')

  permission_string = ''

  3.times do |i|
    permission_string += FILE_PERMISSION_TO_CHAR[file_permissions[i]]
  end

  permission_string
end

main
