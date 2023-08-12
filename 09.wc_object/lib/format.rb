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
    each_text_counts = store_all_counts(@texts)
    text_counts_max_width = each_text_counts.flatten.max

    total_counts = calc_total(each_text_counts) if @texts.size >= 2
    total_counts_max_width = total_counts&.max || 0

    width = [text_counts_max_width, total_counts_max_width].max.to_s.length

    body_format =
      @texts.map do |text|
        counts_format = store_counts(text).map { |count| rjust_width(count, width) }
        line_format = counts_format << text.source_path
        line_format.join(' ')
      end

    if @texts.size >= 2
      total_counts = total_counts
      total_format = total_counts.map { |total| total.to_s.rjust(width) }.join(' ')
      total_format << ' total'
      total_format
    end

    all_lines = total_format ? body_format.push(total_format) : body_format
    all_lines
  end

  private

  def calc_total(counts)
    counts.transpose.map(&:sum)
  end

  def store_all_counts(texts)
    texts.map { |text| store_counts(text) }
  end

  def store_counts(text)
    count_list = []
    count_list << text.lines if @show_lines
    count_list << text.words if @show_words
    count_list << text.bytesize if @show_bytesize
    count_list
  end

  def rjust_width(content, width)
    content.to_s.rjust(width)
  end
end
