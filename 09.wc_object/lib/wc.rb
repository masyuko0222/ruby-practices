require_relative './params'
require_relative './wc_file'

class Wc
  def self.main
    params = Params.new(ARGV)
    options = params.options
    file_paths = params.file_paths

    text = file_paths.empty? ? $stdin.read : ''
    wc_files = file_paths.empty? ? [] : WcFile.all(file_paths)

    if file_paths.size >= 2
      #puts TotalFormat.new(**options, text, wc_files).render
    else
      puts DefaultFormat.new(text, wc_files, **options).render
    end
  end
end

Wc.main
