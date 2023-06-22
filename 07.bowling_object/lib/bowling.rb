#frozen_string_literal: true
require_relative 'game'

shots = ARGV[0]
game = Game.new(shots)

puts game.score
