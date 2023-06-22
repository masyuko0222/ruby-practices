require 'minitest/autorun'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def test_case_1
    shots = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    game = Game.new(shots)

    assert_equal 139, game.score
  end

  def test_case_2
    shots = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    game = Game.new(shots)

    assert_equal 164, game.score
  end

  def test_case_3
    shots = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    game = Game.new(shots)

    assert_equal 107, game.score
  end
end
