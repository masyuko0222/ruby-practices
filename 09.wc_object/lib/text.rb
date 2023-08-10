# frozen_string_literal: true

require 'pathname'

class Text
  def self.all(file_paths)
    paths = file_paths.empty? ? [''] : file_paths

    paths.map do |path|
      Text.new(path)
    end
  end

  def initialize(path)
    @text = path.empty? ? $stdin.read : Pathname.new(path).read
  end

  def lines
    @text.count("\n")
  end

  def words
    @text.split(/\s+/).length
  end

  def bytesize
    @text.bytesize
  end
end
