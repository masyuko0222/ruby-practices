# frozen_string_literal: true

class Format
  def initialize(texts = [], show_lines: false, show_words: false, show_bytesize: false)
    @texts = texts
    @show_lines = show_lines
    @show_words = show_words
    @show_bytesize = show_bytesize
  end

  def render
    counts_list =
      @texts.map do |text|
        counts = []
        counts << text.lines if @show_lines
        counts << text.words if @show_words
        counts << text.bytesize if @show_bytesize
        counts
      end

    count_width = calc_max_count_width(counts_list)

    #if @texts.size <= 1
    #  one_line_format
    #else
    #  total_format
    #end
  end

  private

  def calc_max_count_width(counts_list)
    if counts_list.size <= 1
      counts_list.first.map { |count| count }.max.to_s.length
    else
      # 合計値も出力する場合、当然合計値の各カウントの方が幅は大きくなるので、そちらからmax_widthを計算する。
      counts_list.transpose.map(&:sum).max.to_s.length
    end
  end
end
