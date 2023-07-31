class SingleFileFormat
  def initialize(wc_files, lines_count: false, words_count: false, byte_size: false)
    @wc_file = wc_files[0] # wc_filesには必ず1つのファイルしかない(このクラスでは)ため、それのみを取り出しておく。
    @lines_count = lines_count
    @words_count = words_count
    @byte_size = byte_size
  end

  def render
    width = calc_width

    formatted_count_list = []

    formatted_count_list << @wc_file.count_lines.to_s.rjust(width) if @lines_count
    formatted_count_list << @wc_file.count_words.to_s.rjust(width) if @words_count
    formatted_count_list << @wc_file.count_byte_size.to_s.rjust(width) if @byte_size
    formatted_count_list << @wc_file.name

    formatted_count_list.join(' ')
  end

  private

  def calc_width
    [
      @wc_file.count_lines,
      @wc_file.count_words,
      @wc_file.count_byte_size,
    ].map { |count| count.to_s.length }.max
  end
end
