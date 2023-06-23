#frozen_string_literal

require 'minitest/autorun'
require_relative '../lib/shot'

class ShotTest < Minitest::Test
  def test_case1
    mark = 'X'
    shot = Shot.new(mark)

    assert_equal 10, shot.score
  end

  def test_case2
    mark = '0'
    shot = Shot.new(mark)

    assert_equal 0, shot.score
  end

  def test_case3
    mark = '5'
    shot = Shot.new(mark)

    assert_equal 5, shot.score
  end
end
