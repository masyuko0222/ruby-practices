class DefaultFormat
  def initialize(text = '', wc_files = [], lines_opt: false, words_opt: false, byte_size_opt: false)
    @text = text
    @wc_files = wc_files
    @lines_opt = lines_opt
    @words_opt = words_opt
    @byte_size_opt = byte_size_opt
  end

  def render
    if @wc_files.empty?
      stdin_format(@text)
    else
      single_file_format(*@wc_files) # Only 1 WcFile
    end
  end

  private

  def stdin_format(text)
    counts = []
    counts << text.count("\n") if @lines_opt
    counts << text.split(/\s+/).size if @words_opt
    counts << text.bytesize if @byte_size_opt

    width = counts.map { |count| count.to_s.length }.max

    counts_format = counts.map { |count| count.to_s.rjust(width) }
    counts_format.join(' ')
  end

  def single_file_format(wc_file)
    counts = store_counts(wc_file)
    width = counts.map { |count| count.to_s.length }.max

    counts_format = counts.map { |count| count.to_s.rjust(width) }
    counts_format << wc_file.path
    counts_format.join(' ')
  end

  def store_counts(wc_file)
    counts = []
    counts << wc_file.count_lines if @lines_opt
    counts << wc_file.count_words if @words_opt
    counts << wc_file.count_byte_size if @byte_size_opt

    counts
  end
end
