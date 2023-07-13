# frozen_string_literal: true

require_relative './files'
require_relative './file_status'

class FilesForLongFormat
  def initialize(options)
    @files = Files.new(options).load
  end

  def organize
    @files.map { |file| load_status(file) }
  end

  private

  def load_status(file)
    FileStatus.new(file).load
  end
end
