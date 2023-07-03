# frozen_string_literal:true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def calculate_score_with_bonus(frame_number, scores_for_bonus)
    if frame_number == 9 # last frame
      score
    elsif strike?
      score + scores_for_bonus.slice(0, 2).sum
    elsif spare?
      score + scores_for_bonus.fetch(0)
    else
      score
    end
  end

  def store_bonus_scores(next_frame = nil, after_next_frame = nil)
    [next_frame, after_next_frame].compact.map(&:store_shot_scores).flatten
  end

  def score
    shot_scores = store_shot_scores
    shot_scores.sum
  end

  def store_shot_scores
    [@first_shot, @second_shot, @third_shot].map(&:score).compact
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    @first_shot.score + @second_shot.score == 10
  end
end
