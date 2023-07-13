# frozen_string_literal: true

require_relative './files'

COLUMN_LENGTH = 3

class FilesForShortFormat
  def initialize(options)
    @options = options
    @files = Files.new(options).load
  end

  def organize
    line_length = calculate_line_length
    adding_nil_count = count_nil_for_adding

    @files += Array.new(adding_nil_count)

    @files.each_slice(line_length).to_a.transpose
  end

  private

  def count_nil_for_adding
    line_length = calculate_line_length

    line_length * COLUMN_LENGTH - @files.size
  end

  def calculate_line_length
    (@files.size.to_f / COLUMN_LENGTH).ceil
  end
end
