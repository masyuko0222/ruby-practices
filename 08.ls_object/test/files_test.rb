# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/files'

class FilesTest < Minitest::Test
  def test_load_all_files_option
    files = Files.new(all_files: true)

    expected_files = Dir.entries('../fixtures').sort_by(&:downcase)

    assert_equal(expected_files, files.load)
  end

  def test_load_reverse_option
    files = Files.new(reverse_in_sort: true)

    expected_files = Dir.entries('../fixtures').sort_by(&:downcase).grep_v(/^\./).reverse

    assert_equal(expected_files, files.load)
  end

  def test_load_with_all_files_and_reverse_options
    files = Files.new(all_files: true, reverse_in_sort: true)

    expected_files = Dir.entries('../fixtures').sort_by(&:downcase).reverse

    assert_equal(expected_files, files.load)
  end
end
