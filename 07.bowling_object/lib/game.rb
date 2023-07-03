# frozen_string_literal:true

require_relative 'frame'

class Game
  def initialize(marks)
    @frames = store_frames(marks)
  end

  def store_frames(marks)
    frames = []
    temporary_marks = []

    marks.each_with_index do |mark, index|
      temporary_marks << mark

      if frames.size < 9
        if temporary_marks.size >= 2 || mark == 'X'
          frames << Frame.new(*temporary_marks)
          temporary_marks.clear
        end
      elsif index == marks.count - 1
        frames << Frame.new(*temporary_marks)
      end
    end

    frames
  end

  def score
    10.times.sum do |frame_number|
      frame, next_frame, after_next_frame = @frames.slice(frame_number, 3)

      scores_for_bonus = frame.store_bonus_scores(next_frame, after_next_frame)

      frame.calculate_score_with_bonus(frame_number, scores_for_bonus)
    end
  end
end
