# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
  def test_calculate_score_with_bonus_strike_last_frame
    frame = Frame.new(10, 5, 4)
    frame_number = 9
    bonus_scores = []

    assert_equal 19, frame.calculate_score_with_bonus(frame_number, bonus_scores)
  end

  def test_calculate_score_with_bonus_strike_case1
    frame = Frame.new(10)
    frame_number = 3
    bonus_scores = [5, 3, 4, 5]

    assert_equal (10 + 5 + 3), frame.calculate_score_with_bonus(frame_number, bonus_scores)
  end

  def test_calculate_score_with_bonus_strike_case2
    frame = Frame.new(10)
    frame_number = 3
    bonus_scores = [10, 4, 5]

    assert_equal (10 + 10 + 4), frame.calculate_score_with_bonus(frame_number, bonus_scores)
  end

  def test_calculate_score_with_bonus_spare_case1
    frame = Frame.new(5, 5)
    frame_number = 3
    bonus_scores = [5, 3, 4, 5]

    assert_equal (10 + 5), frame.calculate_score_with_bonus(frame_number, bonus_scores)
  end

  def test_store_bonus_scores_case1
    frame = Frame.new(10)
    next_frame = Frame.new(10)
    after_next_frame = Frame.new(4, 5)

    assert_equal [10, 4, 5], frame.store_bonus_scores(next_frame, after_next_frame)
  end

  def test_store_bonus_scores_last_frame
    frame = Frame.new(5, 5, 5)

    assert_equal [], frame.store_bonus_scores
  end

  def test_score_case1
    frame = Frame.new(10)

    assert_equal 10, frame.score
  end

  def test_score_case2
    frame = Frame.new(2, 7)

    assert_equal 9, frame.score
  end

  def test_score_case3
    frame = Frame.new(10, 10, 10)

    assert_equal 30, frame.score
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
