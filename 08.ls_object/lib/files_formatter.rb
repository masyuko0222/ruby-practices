# frozen_string_literal: true

require_relative './files_for_short_format'
require_relative './files_for_long_format'

class FilesFormatter
  def initialize(options)
    @options = options
    @organized_files = options[:long_format] ? FilesForLongFormat.new(options).organize : FilesForShortFormat.new(options).organize
  end

  def format
    @options[:long_format] ? long_format : short_format
  end

  private

  def long_format
    total_block = "total #{calculate_total_block}"
    length_of_max_file_size = calculate_max_file_size_length

    formatted_table =
      @organized_files.map do |information|
        formatted_string = [
          information[:file_type],
          information[:file_permission].to_s,
          " #{information[:hardlink_count]}",
          " #{information[:user_name]}",
          " #{information[:group_name]}",
          " #{information[:file_size].to_s.rjust(length_of_max_file_size)}",
          " #{information[:time_stamp]}",
          " #{information[:file_name]}"
        ].join

        formatted_string += " -> #{File.readlink(information[:file_name])}" if information[:symlink?]

        formatted_string
      end

    [total_block, *formatted_table]
  end

  def calculate_total_block
    @organized_files.sum { |information| information[:block_size] / 2 }
  end

  def calculate_max_file_size_length
    @organized_files.map { |information| information[:file_size] }.max.to_s.length
  end

  def short_format
    max_file_name_length = calculate_max_file_name_length

    @organized_files.map do |files_in_line|
      files_in_line.map do |file|
        file.ljust(max_file_name_length + 1)
      end.join.rstrip
    end
  end

  def calculate_max_file_name_length
    @organized_files.flatten.max_by(&:length).length
  end
end
