class DefaultFormat
  def initialize(text = '', wc_files = [], lines_opt: false, words_opt: false, byte_size_opt: false)
    @text = text
    @wc_files = wc_files
    @options = { lines_opt: lines_opt, words_opt: words_opt, byte_size_opt: byte_size_opt }
  end

  def render
    if @wc_files.empty?
      stdin_format(@text)
    else
      single_file_format(*@wc_files) # Only 1 WcFile
    end
  end

  private

  def single_file_format(wc_file)
    width = calc_width(wc_file)

    [
      wc_file.count_lines.to_s.rjust(width),
      wc_file.count_words.to_s.rjust(width),
      wc_file.count_byte_size.to_s.rjust(width),
      wc_file.path
    ].join(' ')
  end

  def calc_width(wc_file)
    [
      wc_file.count_lines,
      wc_file.count_words,
      wc_file.count_byte_size,
    ].map { |count| count.to_s.length }.max
  end
end
