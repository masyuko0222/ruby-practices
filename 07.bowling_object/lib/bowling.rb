# frozen_string_literal:true

marks = ARGV[0].split(',')
game = Game.new(marks)

p game.score
