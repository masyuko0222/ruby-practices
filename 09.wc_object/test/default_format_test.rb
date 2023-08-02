# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/default_format'
require_relative '../lib/wc_file'

class DefaultFormatTest < Minitest::Test
  def test_same_digits_with_all_options
    options = { lines_opt: true, words_opt: true, byte_size_opt: true }
    text = ''
    file_paths = ['test/fixtures/1_1_2.txt']
    wc_files = WcFile.all(file_paths)

    expected = '1 1 2 test/fixtures/1_1_2.txt'

    assert_equal expected, DefaultFormat.new(text, wc_files, **options).render
  end

  def test_different_digits_with_all_options
    options = { lines_opt: true, words_opt: true, byte_size_opt: true }
    text = ''
    file_paths = ['test/fixtures/9_99_504.txt']
    wc_files = WcFile.all(file_paths)

    expected = '  9  99 504 test/fixtures/9_99_504.txt'

    assert_equal expected, DefaultFormat.new(text, wc_files, **options).render
  end

  def test_same_digits_with_a_option
    options = { lines_opt: true }
    text = ''
    file_paths = ['test/fixtures/1_1_2.txt']
    wc_files = WcFile.all(file_paths)

    expected = '1 test/fixtures/1_1_2.txt'

    assert_equal expected, DefaultFormat.new(text, wc_files, **options).render
  end

  def test_different_digits_with_two_options
    options = { words_opt: true, byte_size_opt: true }
    text = ''
    file_paths = ['test/fixtures/9_99_504.txt']
    wc_files = WcFile.all(file_paths)

    expected = ' 99 504 test/fixtures/9_99_504.txt'

    assert_equal expected, DefaultFormat.new(text, wc_files, **options).render
  end

  def test_stdin_all_options
    options = { lines_opt: true, words_opt: true, byte_size_opt: true }
    text = <<~TEXT
      This is a great text.
      You should check me.
    TEXT

    file_paths = []
    wc_files = WcFile.all(file_paths)

    expected = ' 2  9 43'

    assert_equal expected, DefaultFormat.new(text, wc_files, **options).render
  end
end
