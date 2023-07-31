class Wc
  def main
    params = Params.new(ARGV)
    target_paths = parms.target_paths
    options = params.options

    wc_files = WcFile.new(target_paths)

    if target_paths.size >= 2
      puts TotalFormats.new(options).render
    else
      puts SingleFileFormat.new(options).render
    end
  end
end

Wc.new.main
