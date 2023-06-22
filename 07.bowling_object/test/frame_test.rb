require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
  def test_score_case_normal
    frame = Frame.new('1', '8')

    assert_equal 9, frame.score
  end

  def test_score_case_strike
    frame = Frame.new('X')

    assert_equal 10, frame.score
  end

  def test_score_case_3shots
    frame = Frame.new('1', '9', 'X')

    assert_equal 20, frame.score
  end
end
