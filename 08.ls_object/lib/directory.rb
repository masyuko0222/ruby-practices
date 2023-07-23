# frozen_string_literal: true

class Directory
  def initialize(all_files: false, reverse_in_sort: false, long_format: false)
    @all_files = all_files
    @reverse_in_sort = reverse_in_sort
  end

  def load_file_names
    all_files = Dir.entries('.').sort_by(&:downcase)

    filtered_files = @all_files ? all_files : all_files.grep_v(/^\./)

    @reverse_in_sort ? filtered_files.reverse : filtered_files
  end
end
