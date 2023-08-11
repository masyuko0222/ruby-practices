require 'minitest/autorun'
require_relative '../lib/text'
require_relative '../lib/format'

class FormatTest < Minitest::Test
  def setup
    one_file_path = ['test/fixtures/2_5_10.txt']
    @one_file_text = Text.all(one_file_path)

    file_paths = ['test/fixtures/2_5_10.txt', 'test/fixtures/8_4_236.txt']
    @texts = Text.all(file_paths)
  end

  def test_a_file_with_all_options
    options = { show_lines: true, show_words: true, show_bytesize: true }
    expected = [' 2  5 10 test/fixtures/2_5_10.txt']

    assert_equal expected, Format.new(@one_file_text, **options).format
  end

  def test_a_file_with_show_lines_option
    options = { show_lines: true, show_words: false, show_bytesize: false }
    expected = ['2 test/fixtures/2_5_10.txt']

    assert_equal expected, Format.new(@one_file_text, **options).format
  end

  def test_some_files_with_all_options
    options = { show_lines: true, show_words: true, show_bytesize: true }
    expected = [
      '  2   5  10 test/fixtures/2_5_10.txt',
      '  8  40 236 test/fixtures/8_4_236.txt',
      ' 10  45 246 total'
    ]

    assert_equal expected, Format.new(@texts, **options).format
  end
end
