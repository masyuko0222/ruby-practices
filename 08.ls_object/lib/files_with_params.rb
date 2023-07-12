# frozen_string_literal: true

class FilesWithParams
  def initialize(params)
    @params = params
  end

  def load
    all_files = Dir.entries('.').sort

    filtered_files = @params[:all_files] ? all_files : all_files.grep_v(/^\./)

    @params[:reverse_in_sort] ? filtered_files.reverse : filtered_files
  end
end
