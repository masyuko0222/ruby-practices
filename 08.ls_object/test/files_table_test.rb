# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/files_table'

class FilesTableTest < Minitest::Test
  def test_build_for_short_format_without_options
    params = { all_files: false, reverse_in_sort: false }

    file_table = FilesTable.new(params)

    expected_table = [
      ['THIS_IS_BIG_FILE', 'loooooooooooooooooooooooooooooooooooooooongtext.txt', 'shortfolder'],
      ['THIS_IS_BIG_FOLDER', 'nine', 'six'],
      ['aggressive_link', 'old.rb', 'ten'],
      ['eight', 'one', 'this_is_small_file'],
      ['five', 'passive_link', 'this_is_small_folder'],
      ['four', 'seven', 'three'],
      ['loooooooooooooooooooooooooooooooooooooooongfolder', 'short.txt', 'two'],
    ]

    assert_equal expected_table, file_table.build
  end

  def test_build_for_long_format
    params = { long_format: true }

    file_table = FilesTable.new(params)

    expected_table = [
      
    ]
  end
end