require 'minitest/autorun'
require_relative '../lib/shot'

class ShotTest < Minitest::Test
  def test_case_X
    shot = Shot.new('X')

    assert_equal 10, shot.score
  end

  def test_case_0
    shot = Shot.new('0')

    assert_equal 0, shot.score
  end

  def test_case_5
    shot = Shot.new('5')

    assert_equal 5, shot.score
  end
end
