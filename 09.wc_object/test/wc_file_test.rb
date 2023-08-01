# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/wc_file'

class WcFileTest < Minitest::Test
  def test_same_digits
    path = 'test/fixtures/1_1_2.txt'
    wc_file = WcFile.new(path)

    assert_equal 1, wc_file.count_lines
    assert_equal 1, wc_file.count_words
    assert_equal 2, wc_file.count_byte_size
  end

  def test_different_digits
    path = 'test/fixtures/9_99_504.txt'
    wc_file = WcFile.new(path)

    assert_equal 9, wc_file.count_lines
    assert_equal 99, wc_file.count_words
    assert_equal 504, wc_file.count_byte_size
  end
end
