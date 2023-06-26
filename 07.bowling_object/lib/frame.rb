# frozen_string_literal:true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    shot_scores = store_shot_scores
    shot_scores.sum
  end

  def store_shot_scores
    [@first_shot, @second_shot, @third_shot].reject(&:nil?).map(&:score)
  end
end