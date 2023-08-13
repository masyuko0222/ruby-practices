# frozen_string_literal: true

class Format
  def initialize(texts = [], show_lines: false, show_words: false, show_bytesize: false)
    @texts = texts
    @show_lines = show_lines
    @show_words = show_words
    @show_bytesize = show_bytesize
  end

  def render
    count_width = calc_max_count_width(@texts)

    if @texts.size == 1
      line_format(@texts, count_width)
    else
      total_format(@texts, count_width)
    end
  end

  private

  def calc_max_count_width(texts)
    counts_list = texts.map { |text| store_counts(text) }

    if texts.size == 1
      counts_list.flatten.max.to_s.length
    else
      # If you will output total line, total values are max number.
      # So max width is based on total(sum) values.
      counts_list.transpose.map(&:sum).max.to_s.length
    end
  end

  def line_format(texts, width)
    texts.map do |text|
      counts = store_counts(text)
      counts_format = counts.map { |count| count.to_s.rjust(width) }
      line_format = counts_format << text.source_path
      line_format.join(' ')
    end
  end

  def total_format(texts, width)
    lines_format = line_format(texts, width)
    counts_list = texts.map { |text| store_counts(text) }
    total_counts = counts_list.transpose.map(&:sum)

    total_counts_format = total_counts.map { |total_count| total_count.to_s.rjust(width) }
    total_format = total_counts_format << 'total'
    total_format = total_format.join(' ')

    lines_format << total_format
  end

  def store_counts(text)
    counts = []
    counts << text.lines if @show_lines
    counts << text.words if @show_words
    counts << text.bytesize if @show_bytesize
    counts
  end
end
