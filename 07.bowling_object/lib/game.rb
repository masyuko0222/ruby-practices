#frozen_string_literal: true
require_relative 'shot'
require_relative 'frame'
require 'debug'

class Game
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def score
    scores = record_shot_scores
    frames = store_shots_scores_to_frames(scores)

    score = 0
    (0..9).each do |n|
      first_frame, second_frame, third_frame = frames.slice(n, 3)
      second_frame ||= []
      third_frame ||= []
      left_shots = second_frame + third_frame

      a_frame = Frame.new(*first_frame)

      if a_frame.first_shot.score == 10
        score += a_frame.score + left_shots.slice(0,2).sum
      elsif a_frame.score == 10
        score += a_frame.score + left_shots.slice(0,1).sum
      else
        score += a_frame.score
      end
    end

    score
  end

  private

  def record_shot_scores
    shots.split(',').map { |shot| Shot.new(shot).score }
  end

  def store_shots_scores_to_frames(scores)
    frames = []
    frame = []

    scores.each do |score|
      frame << score

      if frames.size < 10
        if frame.size >= 2 || score == 10
          frames << frame.dup
          frame.clear
        end
      elsif
        frames.last << score
      end
    end

    frames
  end
end
