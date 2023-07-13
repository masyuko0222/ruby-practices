# frozen_string_literal: true

require_relative './files'
require_relative './file_information'

COLUMN_LENGTH = 3

class OrganizedFiles
  def initialize(options)
    @options = options
    @files = Files.new(options).load
  end

  def build
    @options[:long_format] ? build_for_long_format : build_for_short_format
  end

  private

  def build_for_short_format
    line_length = calculate_line_length
    adding_nil_count = count_nil_for_adding

    @files += Array.new(adding_nil_count)

    @files.each_slice(line_length).to_a.transpose
  end

  def count_nil_for_adding
    line_length = calculate_line_length

    line_length * COLUMN_LENGTH - @files.size
  end

  def calculate_line_length
    (@files.size.to_f / COLUMN_LENGTH).ceil
  end

  def build_for_long_format
    @files.map { |file| FileInformation.new(file).load }
  end
end
