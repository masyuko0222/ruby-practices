require 'pathname'

class WcFile
  def self.all(paths)
    paths.map do |path|
      WcFile.new(path)
    end
  end

  def initialize(path)
    @path_name = Pathname.new(path)
  end

  def count_lines
    read_file.lines.count
  end

  def count_words
    read_file.split(/\s+/).size
  end

  def count_byte_size
    File.size(@path_name)
  end

  private

  def read_file
    File.read(@path_name)
  end

  # For debug
  def to_s
    @path_name.basename.to_s
  end
end
