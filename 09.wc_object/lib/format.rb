# frozen_string_literal: true
require 'debug'
class Format
  def initialize(texts = [], show_lines: false, show_words: false, show_bytesize: false)
    @texts = texts
    @show_lines = show_lines
    @show_words = show_words
    @show_bytesize = show_bytesize
  end

  def format
    each_text_counts =
      @texts.map do |text|
        count_list = []
        count_list << text.lines if @show_lines
        count_list << text.words if @show_words
        count_list << text.bytesize if @show_bytesize
        count_list
      end

    total_counts =
      @texts.map do |text|
        count_list = []
        count_list << text.lines if @show_lines
        count_list << text.words if @show_words
        count_list << text.bytesize if @show_bytesize
      end.transpose.map(&:sum) if @texts.size >= 2

    total_counts_max_width = total_counts&.max || 0
    width = [each_text_counts.flatten.max, total_counts_max_width].max.to_s.length

    count_line =
      @texts.map do |text|
        count_list = []
        count_list << text.lines.to_s.rjust(width) if @show_lines
        count_list << text.words.to_s.rjust(width) if @show_words
        count_list << text.bytesize.to_s.rjust(width) if @show_bytesize
        count_list << text.source_path
        count_list.join(' ')
      end

    if @texts.size >= 2
      total_line =
        @texts.map do |text|
          count_list = []
          count_list << text.lines if @show_lines
          count_list << text.words if @show_words
          count_list << text.bytesize if @show_bytesize
        end.transpose.map(&:sum).map { |total| total.to_s.rjust(width) }.join(' ')

        total_line << ' total'
        total_line
    end

    all_lines = total_line ? count_line.push(total_line) : count_line
    all_lines
  end

  private

end
