# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
  def test_score_case_normal
    frame = Frame.new(5, 3)
    frame_number = 1

    assert_equal 8, frame.score(frame_number)
  end

  def test_score_case_strike_and_next_frame_is_normal
    frame = Frame.new(10)
    frame_number = 1
    next_frame = Frame.new(5, 3)

    assert_equal 18, frame.score(frame_number, next_frame)
  end

  def test_store_store_shot_scores_case1
    frame = Frame.new(10)

    assert_equal [10], frame.store_shot_scores
  end

  def test_store_store_shot_scores_case2
    frame = Frame.new(2, 7)

    assert_equal [2, 7], frame.store_shot_scores
  end

  def test_store_store_shot_scores_case3
    frame = Frame.new(10, 10, 10)

    assert_equal [10, 10, 10], frame.store_shot_scores
  end

  def test_strike?
    frame = Frame.new(10)

    assert frame.strike?
  end

  def test_spare?
    frame = Frame.new(6, 4)

    assert frame.spare?
  end
end
