# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/file_table'

class FileTableTest < Minitest::Test
  def test_build_without_options
    params = { all_files: false, reverse_in_sort: false }

    file_table = FileTable.new(params)

    expected_file_table = [
      ['THIS_IS_BIG_FILE', 'loooooooooooooooooooooooooooooooooooooooongtext.txt', 'six'],
      ['THIS_IS_BIG_FOLDER', 'nine', 'ten'],
      ['aggressive_link', 'one', 'this_is_small_file'],
      ['eight', 'passive_link', 'this_is_small_folder'],
      ['five', 'seven', 'three'],
      ['four', 'short.txt', 'two'],
      ['loooooooooooooooooooooooooooooooooooooooongfolder', 'shortfolder', nil],
    ]

    assert_equal(expected_file_table, file_table.build)
  end

  def test_build_with_all_options
    params = { all_files: true, reverse_in_sort: true }

    file_table = FileTable.new(params)

    expected_file_table = [
      ['two', 'seven', 'eight'],
      ['three', 'passive_link', 'aggressive_link'],
      ['this_is_small_folder', 'one', 'THIS_IS_BIG_FOLDER'],
      ['this_is_small_file', 'nine', 'THIS_IS_BIG_FILE'],
      ['ten', 'loooooooooooooooooooooooooooooooooooooooongtext.txt', '..'],
      ['six', 'loooooooooooooooooooooooooooooooooooooooongfolder', '.'],
      ['shortfolder', 'four', nil],
      ['short.txt', 'five', nil],
    ]

    assert_equal(expected_file_table, file_table.build)
  end
end
