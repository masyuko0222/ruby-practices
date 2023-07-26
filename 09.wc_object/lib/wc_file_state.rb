class WcFileState
  def self.store_all(params)
    params.target_paths.map do |path|
      p WcFileState.new(path).size_count
    end
  end

  def initialize(path)
    @path_name = path
  end

  def line_count
    File.read("#{@path_name}").lines.count
  end

  def words_count
    File.read("#{@path_name}").split.size
  end

  def size_count
    File.size("#{@path_name}")
  end
end
