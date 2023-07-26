# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/directory'

class DirectoryTest < Minitest::Test
  def test_load_files_all_files_option
    directory = Directory.new(all_files: true)

    expected_files = Dir.entries('../fixtures').sort_by(&:downcase)

    assert_equal(expected_files, directory.load_file_names)
  end

  def test_load_files_reverse_option
    directory = Directory.new(reverse_in_sort: true)

    expected_files = Dir.entries('../fixtures').sort_by(&:downcase).grep_v(/^\./).reverse

    assert_equal(expected_files, directory.load_file_names)
  end

  def test_load_files_with_all_files_and_reverse_options
    directory = Directory.new(all_files: true, reverse_in_sort: true)

    expected_files = Dir.entries('../fixtures').sort_by(&:downcase).reverse

    assert_equal(expected_files, directory.load_file_names)
  end
end
