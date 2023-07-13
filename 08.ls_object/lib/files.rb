# frozen_string_literal: true

class Files
  def initialize(options)
    @options = options
  end

  def load
    all_files = Dir.entries('.').sort_by(&:downcase)

    filtered_files = @options[:all_files] ? all_files : all_files.grep_v(/^\./)

    @options[:reverse_in_sort] ? filtered_files.reverse : filtered_files
  end
end
