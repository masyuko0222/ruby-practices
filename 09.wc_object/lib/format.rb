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

    if single_text?
      format(@texts, count_width)
    else
      format_with_total(@texts, count_width)
    end
  end

  private

  # methods used in `render` method
  def single_text?
    @texts.size == 1
  end

  def calc_max_count_width(texts)
    counts_list = texts.map { |text| store_counts(text) }

    if single_text?
      counts_list.flatten.max.to_s.length
    else
      # If you will output total line, total value is max number.
      # So max width is based on total(sum) values.
      calc_total_of_each_counts(counts_list).max.to_s.length
    end
  end

  def format(texts, width)
    texts.map do |text|
      counts = store_counts(text)
      formatted_counts = rjust_counts_width(counts, width)
      line_format = formatted_counts << text.source_path
      line_format.join(' ')
    end
  end

  def format_with_total(texts, width)
    counts_list = texts.map { |text| store_counts(text) }
    total_line_format = format_line_of_total(counts_list, width)

    counts_format = format(texts, width)
    counts_format << total_line_format
  end

  # sub methods
  def store_counts(text)
    counts = []
    counts << text.lines if @show_lines
    counts << text.words if @show_words
    counts << text.bytesize if @show_bytesize
    counts
  end

  def calc_total_of_each_counts(counts_list)
    counts_list.transpose.map(&:sum)
  end

  def format_line_of_total(counts_list, width)
    total_counts = calc_total_of_each_counts(counts_list)
    total_counts_format = rjust_counts_width(total_counts, width)
    total_line_format = total_counts_format << 'total'
    total_line_format.join(' ')
  end

  def rjust_counts_width(counts, width)
    counts.map { |count| count.to_s.rjust(width) }
  end
end
