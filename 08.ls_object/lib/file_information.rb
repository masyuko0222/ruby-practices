# frozen_string_literal: true

FILE_TYPE_TO_CHAR = {
  'directory' => 'd',
  'file' => '-',
  'link' => 'l',
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

class FileInformation
  def initialize(file_name)
    @file_name = file_name
  end

  def load
    base_information = load_base_information

    base_information.store(:link_to, File.readlink(@file_name)) if base_information[:symlink?]

    base_information
  end

  private

  def load_base_information
      {
        file_type: change_file_type_to_char,
        file_permission: change_file_permission_to_string,
        hardlink_count: count_hardlink,
        user_name: fetch_user_name,
        group_name: fetch_group_name,
        file_size: load_file_size,
        time_stamp: parse_time_stamp,
        file_name: @file_name,
        symlink?: symlink?(@file_name)
      }
  end

  def file_link_and_status
    File.lstat(@file_name)
  end

  def change_file_type_to_char
    FILE_TYPE_TO_CHAR[file_link_and_status.ftype]
  end

  def change_file_permission_to_string
    file_octal_mode = file_link_and_status.mode.to_s(8)

    (-3..-1).map { |i| FILE_PERMISSION_TO_CHAR[file_octal_mode[i]] }.join
  end

  def count_hardlink
    file_link_and_status.nlink
  end

  def fetch_user_name
    Etc.getpwuid(file_link_and_status.uid).name
  end

  def fetch_group_name
    Etc.getpwuid(file_link_and_status.gid).name
  end

  def load_file_size
    file_link_and_status.size
  end

  def parse_time_stamp
    file_link_and_status.mtime.strftime('%b %e %H:%M')
  end

  def symlink?(file_name)
    File.symlink?(file_name)
  end
end
