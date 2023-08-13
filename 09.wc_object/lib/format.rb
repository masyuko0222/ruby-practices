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
      format_lines_of_counts(@texts, count_width)
    else
      format_lines_with_total(@texts, count_width)
    end
  end

  private

  def calc_max_count_width(texts)
    counts_list = texts.map { |text| store_counts(text) }

    if texts.size == 1
      counts_list.flatten.max.to_s.length
    else
      # If you will output total line, total value is max number.
      # So max width is based on total(sum) values.
      counts_list.transpose.map(&:sum).max.to_s.length
    end
  end

  def store_counts(text)
    counts = []
    counts << text.lines if @show_lines
    counts << text.words if @show_words
    counts << text.bytesize if @show_bytesize
    counts
  end

  def format_lines_of_counts(texts, width)
    texts.map do |text|
      counts = store_counts(text)
      formatted_counts = rjust_counts_width(counts, width)
      line_format = formatted_counts << text.source_path
      line_format.join(' ')
    end
  end

  def format_lines_with_total(texts, width)
    counts_format = format_lines_of_counts(texts, width)
    counts_list = texts.map { |text| store_counts(text) }

    total_counts = counts_list.transpose.map(&:sum)
    total_counts_format = rjust_counts_width(total_counts, width)
    total_line_format = total_counts_format << 'total'
    total_line_format = total_line_format.join(' ')

    counts_format << total_line_format
  end

  def rjust_counts_width(counts, width)
    counts.map { |count| count.to_s.rjust(width) }
  end
end
