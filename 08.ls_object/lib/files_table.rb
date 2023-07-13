# frozen_string_literal: true

require_relative './files'
require 'debug'

COLUMN_LENGTH = 3

FILE_TYPE_TO_CHAR = {
  'directory' => 'd',
  'file' => '-',
  'link' => 'l',
}.freeze

FILE_PERMISSION_TO_CHAR = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

class FileTable
  def initialize(params)
    @params = params
    @files = Files.new(params).load
  end

  def build
    table =
      @params[:long_format] ? build_for_long_format : build_for_short_format

      @params[:reverse_in_sort] ? table.reverse : table
  end

  private

  def build_for_short_format
    line_length = (@files.size.to_f / COLUMN_LENGTH).ceil
    adding_nil_count = line_length * COLUMN_LENGTH - @files.size

    @files += Array.new(adding_nil_count)

    @files.each_slice(line_length).to_a.transpose
  end

  private

end
