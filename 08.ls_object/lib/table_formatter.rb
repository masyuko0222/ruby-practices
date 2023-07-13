# frozen_string_literal: true

require_relative './files'
require_relative './files_table'

class TableFormatter
  def initialize(options)
    @options = options
    @files = Files.new(options).load
    @files_table = FilesTable.new(options).build
  end

  def format
    @options[:long_format] ? long_format : short_format
  end

  private

  def short_format
    max_file_name_length = calculate_max_file_name_length

    @files_table.map do |files_in_line|
      files_in_line.map do |file|
        file.ljust(max_file_name_length + 1)
      end.join.rstrip
    end
  end

  def calculate_max_file_name_length
    @files.max_by(&:length).length
  end

  def long_format
    total_block = "total #{calculate_total_block}"
    length_of_max_file_size = calculate_max_file_size_length

    formatted_table =
      @files_table.map do |information|
        formatted_string = information[:file_type] + information[:file_permission] + 
        " #{information[:hardlink_count].to_s}" +
        " #{information[:user_name]}" +
        " #{information[:group_name]}" +
        " #{information[:file_size].to_s.rjust(length_of_max_file_size)}" +
        " #{information[:time_stamp]}" +
        " #{information[:file_name]}"

        formatted_string += " -> #{File.readlink(information[:file_name])}" if information[:symlink?]

        formatted_string
      end

    [total_block, *formatted_table]
  end

  def calculate_total_block
    @files_table.sum { |information| information[:block_size] / 2 }
  end

  def calculate_max_file_size_length
    @files_table.map{ |information| information[:file_size] }.max.to_s.length
  end
end
