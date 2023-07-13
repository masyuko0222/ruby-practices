# frozen_string_literal: true

require_relative './files'

COLUMN_LENGTH = 3

class FilesForShortFormat
  def initialize(options)
    @files = Files.new(options).load
  end

  def organize
    line_length = calculate_line_length
    files_added_nil = add_nil_for_transposing(@files, line_length)

    columnize_files(files_added_nil, line_length)
  end

  private

  def calculate_line_length
    (files_size.to_f / COLUMN_LENGTH).ceil
  end

  def add_nil_for_transposing(files, line_length)
    nil_count = calculate_required_nil_count(line_length)

    files += Array.new(nil_count)
  end

  def calculate_required_nil_count(line_length)
    line_length * COLUMN_LENGTH - files_size
  end

  def files_size
    @files.size
  end

  def columnize_files(files, line_length)
    transposed_files = files.each_slice(line_length).to_a.transpose

    transposed_files.map { |files_in_line| files_in_line.compact }
  end
end
