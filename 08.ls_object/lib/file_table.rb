# frozen_string_literal: true

require_relative './files_with_params'

COLUMN_LENGTH = 3

class FileTable
  def initialize(params)
    @parmas = params
    @files = FilesWithParams.new(params).load
  end

  def build
    line_length = (count_files_size.to_f / COLUMN_LENGTH).ceil

    adding_nil_count = line_length * COLUMN_LENGTH - count_files_size
    @files += Array.new(adding_nil_count)

    @files.each_slice(line_length).to_a.transpose
  end

  private

  def count_files_size # 単純な処理だが、２か所重複しているためDRY化
    @files.size
  end
end
