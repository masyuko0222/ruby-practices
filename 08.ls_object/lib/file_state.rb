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

class FileState
  def initialize(file_name)
    @file_name = file_name
  end

  def load_for_long_format
    file_lstat = fetch_file_lstat

    base_status = {
      file_type: FILE_TYPE_TO_CHAR[file_lstat.ftype],
      file_permission: change_file_permission_to_string,
      hardlink_count: file_lstat.nlink,
      user_name: Etc.getpwuid(fetch_file_lstat.uid).name,
      group_name: Etc.getpwuid(fetch_file_lstat.gid).name,
      file_size: file_lstat.size,
      time_stamp: parse_time_stamp,
      file_name: @file_name,
      block_size: file_lstat.blocks,
      symlink?: File.symlink?(@file_name)
    }

    base_status.store(:link_to, File.readlink(@file_name)) if base_status[:symlink?]

    base_status
  end

  private

  def fetch_file_lstat
    File.lstat(@file_name)
  end

  def change_file_permission_to_string
    file_octal_mode = fetch_file_lstat.mode.to_s(8)

    (-3..-1).map { |i| FILE_PERMISSION_TO_CHAR[file_octal_mode[i]] }.join
  end

  def parse_time_stamp
    fetch_file_lstat.mtime.strftime('%b %e %H:%M')
  end
end
