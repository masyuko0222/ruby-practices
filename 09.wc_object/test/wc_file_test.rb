# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/wc_file'

class WcFileTest < Minitest::Test
  def test_count_lines
    path1 = 'test/fixtures/1_1_7_wc.txt'
    path2 = 'test/fixtures/20_60_374_wc.txt'

    assert_equal 1, WcFile.new(path1).count_lines
    assert_equal 20, WcFile.new(path2).count_lines
  end

  def test_count_words
    path1 = 'test/fixtures/1_1_7_wc.txt'
    path2 = 'test/fixtures/20_60_374_wc.txt'

    assert_equal 1, WcFile.new(path1).count_words
    assert_equal 60, WcFile.new(path2).count_words
  end

  def test_count_byte_size
    path1 = 'test/fixtures/1_1_7_wc.txt'
    path2 = 'test/fixtures/20_60_374_wc.txt'

    assert_equal 7, WcFile.new(path1).count_byte_size
    assert_equal 374, WcFile.new(path2).count_byte_size
  end
end
