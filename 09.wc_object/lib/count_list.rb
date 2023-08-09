# frozen_string_literal: true

require 'pathname'

class CountList
  def self.all(file_paths)
    if file_paths.size >= 1
      file_paths.map do |file_path|
        text = Pathname.new(file_path.to_s).read
        CountList.new(text)
      end
    else
      text = $stdin.read
      [CountList.new(text)]
    end
  end

  def initialize(text)
    @text = text
  end

  def count_lines
    @text.count("\n")
  end

  def count_words
    @text.split(/\s+/).length
  end

  def count_bytesize
    @text.bytesize
  end
end
