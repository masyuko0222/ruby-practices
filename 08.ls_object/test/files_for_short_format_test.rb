# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/files_for_short_format'

class FilesForShortFormatTest < Minitest::Test
  def
    test_organize_without_options
    options = { all_files: false, reverse_in_sort: false, long_format: false }

    files = FilesForShortFormat.new(options)

    expected_files = [
      ['aggressive_link', 'old.rb', 'ten'],
      ['eight', 'one', 'THIS_IS_BIG_FILE'],
      ['five', 'passive_link', 'THIS_IS_BIG_FOLDER'],
      ['four', 'seven', 'this_is_small_file'],
      ['loooooooooooooooooooooooooooooooooooooooongfolder', 'short.txt', 'this_is_small_folder'],
      ['loooooooooooooooooooooooooooooooooooooooongtext.txt', 'shortfolder', 'three'],
      ['nine', 'six', 'two']
    ]

    assert_equal expected_files, files.organize
  end
end
