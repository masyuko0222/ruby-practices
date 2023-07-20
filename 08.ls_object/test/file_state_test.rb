# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/file_state'

class FileStateTest < Minitest::Test
  def test_load_for_long_format_case_normal_file
    file_state = FileState.new('eight')

    expected_state = {
      file_type: '-',
      file_permission: 'rw-r--r--',
      hardlink_count: 1,
      user_name: 'masyuko0222',
      group_name: 'masyuko0222',
      file_size: 0,
      time_stamp: 'Jul 12 14:05',
      file_name: 'eight',
      block_size: 0,
      symlink?: false
    }

    assert_equal expected_state, file_state.load_for_long_format
  end

  def test_load_for_long_format_case_directory
    file_state = FileState.new('loooooooooooooooooooooooooooooooooooooooongfolder')

    expected_state = {
      file_type: 'd',
      file_permission: 'rwxr-xr-x',
      hardlink_count: 2,
      user_name: 'masyuko0222',
      group_name: 'masyuko0222',
      file_size: 4096,
      time_stamp: 'Jul 12 14:06',
      file_name: 'loooooooooooooooooooooooooooooooooooooooongfolder',
      block_size: 8,
      symlink?: false
    }

    assert_equal expected_state, file_state.load_for_long_format
  end

  def test_load_for_long_format_case_soft_link
    file_state = FileState.new('aggressive_link')

    expected_state = {
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

    assert_equal expected_state, file_state.load_for_long_format
  end

  def test_for_short_format_case_normal_file
    file_state = FileState.new('eight')

    expected_state = {
      file_name: 'eight',
      name_size: 5
    }

    assert_equal expected_state, file_state.load_for_short_format
  end
end
