# frozen_string_literal: true
require 'debug'
class Format
  def initialize(file_paths = [], texts = [], show_lines: false, show_words: false, show_bytesize: false)
    @file_paths = file_paths
    @texts = texts
    @show_lines = show_lines
    @show_words = show_words
    @show_bytesize = show_bytesize
  end

  def format
    width = calc_width

    # ex) [Text1, Text2].zip(Path1, Path2) => [[Text1, Path1], [Text2, Path2]]
    @texts.zip(@file_paths).map do |text, file_path|
      tmp_format =
        store_counts_to_array(text).map { |count| rjust_count(count, width) }
      tmp_format << file_path
      tmp_format.join(' ')
    end
  end

  private

  def calc_width
    @texts.map do |text|
      store_counts_to_array(text)
    end.flatten.max.to_s.length
  end

  def rjust_count(count, width)
    count.to_s.rjust(width)
  end

  def store_counts_to_array(text)
    tmp_array = []
    tmp_array << text.lines if @show_lines
    tmp_array << text.words if @show_words
    tmp_array << text.bytesize if @show_bytesize
    tmp_array
  end
end
