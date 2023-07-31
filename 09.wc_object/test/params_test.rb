# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/params'

class ParamsTest < Minitest::Test
  def setup
    @params = Params.new(ARGV)
  end

  def test_lines_count?
    @params.options[:lines_count] = true

    assert @params.lines_count?
  end

  def test_words_count?
    @params.options[:words_count] = true

    assert @params.words_count?
  end

  def test_byte_size?
    @params.options[:byte_size] = true

    assert @params.byte_size?
  end
end
