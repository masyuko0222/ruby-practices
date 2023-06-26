# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def setup
    @marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'.split(',')
    @all_strikes = 'X,X,X,X,X,X,X,X,X,X,X,X'.split(',')
  end

  # def test_store_frames_case1
  #   game = Game.new(@marks)

  #   frame_data = [['6', '3'], ['9', '0'], ['0', '3'], ['8', '2'], ['7', '3'], ['X'], ['9', '1'], ['8', '0'], ['X'], ['6', '4', '5']]

  #   assert_equal frame_data.map{ |data| Frame.new(*data) }, game.store_frames
  # end

  # def test_store_frames_case2
  #   game = Game.new(@all_strikes)

  #   frame_data = [['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X', 'X', 'X'],]

  #   assert_equal frame_data.map{ |data| Frame.new(*data) }, game.store_frames
  # end

  def test_score_case1
    game = Game.new(@marks)

    assert_equal 139, game.score
  end

  def test_score_case2
    game = Game.new(@all_strikes)

    assert_equal 300, game.score
  end
end
