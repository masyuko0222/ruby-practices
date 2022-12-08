# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_LENGTH = 3

def main
  options = load_options
  files = load_files

  if options.empty?
    file_table = build_file_table(files)
    max_filename_length = files.max_by(&:length).length

    display_files_no_option(file_table, max_filename_length)

  elsif options[:l]
    blocks_total = calculate_blocks_total(files)
    max_byte_to_chars_length = load_max_byte_to_chars_length(files)

    display_files_option_l(blocks_total, files, max_byte_to_chars_length)
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

def calculate_blocks_total(files)
  blocks_total = 0

  files.each do |file|
    # blocksメソッドは1024バイトを1ブロックとして扱うが、lsコマンドでは512バイトで1ブロックのため、2で割る(環境変数により修正可能?)
    block_size = File.lstat(file.to_s).blocks / 2
    blocks_total += block_size
  end

  blocks_total
end

def load_max_byte_to_chars_length(files)
  max_bytes_file =
    files.max_by do |file|
      File.lstat(file.to_s).size
    end

  File.lstat(max_bytes_file).size.to_s.length
end

def display_files_option_l(blocks_total, files, max_byte_to_chars_length)
  print "total #{blocks_total}"
  print "\n"

  files.each do |file|
    file_mode = scan_file_mode(file)

    file_mode_string   = convert_mode_to_string(file_mode)
    number_of_hardlink = File.lstat(file.to_s).nlink.to_s
    user_name          = Etc.getpwuid(File.lstat(file.to_s).uid).name
    group_name         = Etc.getgrgid(File.lstat(file.to_s).gid).name
    file_size          = File.lstat(file.to_s).size
    time_stamp         = File.lstat(file.to_s).mtime.strftime('%b %e %H:%M')

    print "#{file_mode_string} "
    print "#{number_of_hardlink} "
    print "#{user_name} #{group_name} "
    print "#{file_size.to_s.rjust(max_byte_to_chars_length)} "
    print "#{time_stamp} "
    print "#{file} "
    print "-> File.readlink(file.to_s)" if File.symlink?(file.to_s)
    print "\n"
  end
end

def scan_file_mode(file)
  file_mode_0o = File.lstat(file.to_s).mode.to_s(8)

  # directoryの場合は8進数表記だと5桁になってしまうため、6桁にしてからscanメソッドを使って2文字ずつに分割しました
  scanned_mode = file_mode_0o.size < 6 ? "0#{file_mode_0o}".scan(/../) : file_mode_0o.scan(/../)

  # "03"→"3"のように1桁は1桁表記にすることで、後のハッシュでのkeyの記述数を減らしました。
  # (例) #BAD  {'01': 'p', '1': 'p', ...}
  #      #GOOD {'1': 'p', ...}
  scanned_mode.map { |mode| mode.delete_prefix('0') }
end

def convert_mode_to_string(file_mode)
  # ファイルタイプ
  file_type_to_char = { '1': 'p', '2': 'c', '4': 'd', '6': 'b', '10': '-', '12': 'l', '14': 's' }

  type_char = file_type_to_char[:"#{file_mode[0]}"]

  # ファイルパーミッション
  file_permission_to_char = { '0': '---', '1': '--x', '2': '-w-', '3': '-wx', '4': 'r--', '5': 'r-x', '6': 'rw-', '7': 'rwx' }

  file_permissions = [file_mode[1], *file_mode[2].chars]

  permission_string = ''
  
  3.times do |i|
    permission_string += file_permission_to_char[:"#{file_permissions[i]}"]
  end

  # ファイルタイプ + ファイルパーミッション
  type_char + permission_string
end

main
