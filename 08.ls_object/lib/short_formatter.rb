# frozen_string_literal: true

COLUMN_LENGTH = 3

class ShortFormatter
  def initialize(file_names)
    @file_names = file_names
  end

  def format
    max_file_name_length = @file_names.max_by(&:length).length
    file_names_table = build_file_names_table(@file_names)

    file_names_table.map do |files_in_line|
      files_in_line.map do |file|
        file.ljust(max_file_name_length + 1)
      end.join.rstrip
    end
  end

  private

  def build_file_names_table(file_names)
    name_files_count = count_file_names_size
    line_length = (name_files_count.to_f / COLUMN_LENGTH).ceil

    file_names_filled_blanks = file_names + Array.new(line_length * COLUMN_LENGTH - name_files_count)

    file_names_filled_blanks.each_slice(line_length).to_a.transpose.map(&:compact)
  end

  def count_file_names_size
    @file_names.size
  end
end
