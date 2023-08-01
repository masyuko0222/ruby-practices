class WcFile
  def self.all(file_paths)
    file_paths.map { |path| WcFile.new(path) }
  end

  def initialize(path)
    @path = path
  end

  def count_lines
    File.read(@path).count("\n")
  end

  def count_words
    File.read(@path).split(/\s+/).size
  end

  def count_byte_size
    File.read(@path).bytesize
  end
end
