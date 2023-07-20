# frozen_string_literal: true

require 'etc'

FILE_TYPE_TO_CHAR = {
  'directory' => 'd',
  'file' => '-',
  'link' => 'l'
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

class FileStatus
  def initialize(file_name)
    @file_name = file_name
  end

  def load_for_long_format
    base_status = {
      file_type: change_file_type_to_char,
      file_permission: change_file_permission_to_string,
      hardlink_count: count_hardlink,
      user_name: fetch_user_name,
      group_name: fetch_group_name,
      file_size: load_file_size,
      time_stamp: parse_time_stamp,
      file_name: @file_name,
      block_size: load_block_size,
      symlink?: File.symlink?(@file_name)
    }

    base_status.store(:link_to, File.readlink(@file_name)) if base_status[:symlink?]

    base_status
  end

  private

  def change_file_type_to_char
    FILE_TYPE_TO_CHAR[fetch_file_lstat.ftype]
  end

  def change_file_permission_to_string
    file_octal_mode = fetch_file_lstat.mode.to_s(8)

    (-3..-1).map { |i| FILE_PERMISSION_TO_CHAR[file_octal_mode[i]] }.join
  end

  def count_hardlink
    fetch_file_lstat.nlink
  end

  def fetch_user_name
    Etc.getpwuid(fetch_file_lstat.uid).name
  end

  def fetch_group_name
    Etc.getpwuid(fetch_file_lstat.gid).name
  end

  def load_file_size
    fetch_file_lstat.size
  end

  def parse_time_stamp
    fetch_file_lstat.mtime.strftime('%b %e %H:%M')
  end

  def load_block_size
    fetch_file_lstat.blocks
  end

  def fetch_file_lstat
    File.lstat(@file_name)
  end
end
