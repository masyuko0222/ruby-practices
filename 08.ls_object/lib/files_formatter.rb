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
      @organized_files.map do |file|
        formatted_string = [
          file[:file_type],
          file[:file_permission].to_s,
          " #{file[:hardlink_count]}",
          " #{file[:user_name]}",
          " #{file[:group_name]}",
          " #{file[:file_size].to_s.rjust(length_of_max_file_size)}",
          " #{file[:time_stamp]}",
          " #{file[:file_name]}"
        ].join

        formatted_string += " -> #{File.readlink(file[:file_name])}" if file[:symlink?]

        formatted_string
      end

    [total_block, *formatted_table]
  end

  def calculate_total_block
    @organized_files.sum { |file| file[:block_size] / 2 }
  end

  def calculate_max_file_size_length
    @organized_files.map { |file| file[:file_size] }.max.to_s.length
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
