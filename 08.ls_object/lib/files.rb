# frozen_string_literal: true

class Files
  def initialize(all_files: false, reverse_in_sort: false)
    @all_files = all_files
    @reverse_in_sort = reverse_in_sort
  end

  def load
    all_files = Dir.entries('.').sort_by(&:downcase)

    filtered_files = @all_files ? all_files : all_files.grep_v(/^\./)

    @reverse_in_sort ? filtered_files.reverse : filtered_files
  end
end
