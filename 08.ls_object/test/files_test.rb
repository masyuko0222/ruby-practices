# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/files'

class FilesTest < Minitest::Test
  def test_load_with_only_all_option
    options = { all_files: true, reverse_in_sort: false }
    files = Files.new(options)

    expected_files = Dir.entries('../fixtures').sort

    assert_equal(expected_files, files.load)
  end

  def test_load_with_only_reverse_option
    options = { all_files: false, reverse_in_sort: true }
    files = Files.new(options)

    expected_files = Dir.entries('../fixtures').sort.grep_v(/^\./).reverse

    assert_equal(expected_files, files.load)
  end

  def test_load_with_all_and_reverse_option
    options = { all_files: true, reverse_in_sort: true }
    files = Files.new(options)

    expected_files = Dir.entries('../fixtures').sort.reverse

    assert_equal(expected_files, files.load)
  end
end
