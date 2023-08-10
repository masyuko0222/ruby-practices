# frozen_string_literal: true

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

    @texts.zip(@file_paths).map do |text, file_path|
      tmp_format = []
      tmp_format << text.lines.to_s.rjust(width) if @show_lines
      tmp_format << text.words.to_s.rjust(width) if @show_words
      tmp_format << text.bytesize.to_s.rjust(width) if @show_bytesize
      tmp_format << file_path
      tmp_format.join(' ')
    end
  end


  def calc_width
    @texts.map do |text|
      tmp_list = []
      tmp_list << text.lines if @show_lines
      tmp_list << text.words if @show_words
      tmp_list << text.bytesize if @show_bytesize
    end.flatten.max.to_s.length
  end
end
