# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/file_status'

class FileStatusTest < Minitest::Test
  def test_load_case_normal_file
    file_name = 'eight'

    file_status = FileStatus.new(file_name)

    expected_information = {
      file_type: '-',
      file_permission: 'rw-r--r--',
      hardlink_count: 1,
      user_name: 'masyuko0222',
      group_name: 'masyuko0222',
      file_size: 0,
      time_stamp: 'Jul 12 14:05',
      file_name: 'eight',
      block_size: 0,
      symlink?: false,
    }

    assert_equal expected_information, file_status.load
  end

  def test_load_case_directory
    file_name = 'loooooooooooooooooooooooooooooooooooooooongfolder'

    file_status = FileStatus.new(file_name)

    expected_information = {
      file_type: 'd',
      file_permission: 'rwxr-xr-x',
      hardlink_count: 2,
      user_name: 'masyuko0222',
      group_name: 'masyuko0222',
      file_size: 4096,
      time_stamp: 'Jul 12 14:06',
      file_name: 'loooooooooooooooooooooooooooooooooooooooongfolder',
      block_size: 8,
      symlink?: false,
    }

    assert_equal expected_information, file_status.load
  end

  def test_load_case_soft_link
    file_name = 'aggressive_link'

    file_status = FileStatus.new(file_name)

    expected_information = {
      file_type: 'l',
      file_permission: 'rwxrwxrwx',
      hardlink_count: 1,
      user_name: 'masyuko0222',
      group_name: 'masyuko0222',
      file_size: 12,
      time_stamp: 'Jul 12 14:07',
      file_name: 'aggressive_link',
      block_size: 0,
      symlink?: true,
      link_to: 'passive_link'
    }

    assert_equal expected_information, file_status.load
  end
end
