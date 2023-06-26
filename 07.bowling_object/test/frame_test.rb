# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
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
end
