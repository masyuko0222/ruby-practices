# frozen_string_literal:true

require_relative 'frame'
require 'debug'

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
      next_frame ||= nil
      after_next_frame ||= nil

      scores_for_bonus = [next_frame, after_next_frame].compact.map(&:store_shot_scores).flatten

      if frame_number == 9 # last frame
        frame.score
      elsif frame.strike?
        frame.score + scores_for_bonus.slice(0, 2).sum
      elsif frame.spare?
        frame.score + scores_for_bonus.fetch(0)
      else
        frame.score
      end
    end
  end
end
