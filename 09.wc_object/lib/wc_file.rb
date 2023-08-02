class WcFile
  def self.all(file_paths)
    file_paths.map { |path| WcFile.new(path) }
  end

  def initialize(path)
    @path = path
  end

  def count_lines
    file_content.count("\n")
  end

  def count_words
    file_content.split(/\s+/).size
  end

  def count_byte_size
    file_content.bytesize
  end

  private

  def file_content
    File.read(@path)
  end
end
