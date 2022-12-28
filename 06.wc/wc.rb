require 'optparse'

def main
  options = load_options
  read_files = ARGV.map{|file| File.open(file)}

  display_file_wc_format(options, read_files)
end

def load_options
  opt = OptionParser.new

  params = {}

  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }

  opt.parse!(ARGV)

  params
end

def display_file_wc_format(options, read_files)
  file_wc_info_lists = build_wc_info_lists(read_files)

  file_wc_info_lists.each do |list|
    print " #{list[:line_count].to_s.rjust(4)}" if options.size == 0 || options[:l]
    print " #{list[:word_count].to_s.rjust(4)}" if options.size == 0 || options[:w]
    print " #{list[:byte_size].to_s.rjust(4)}" if options.size == 0 || options[:c]
    print " #{list[:file_name]}"
    puts
  end
end

def build_wc_info_lists(files)
  files.map do |file|
    read_file = file.read
    {
      line_count: read_file.lines.count,
      word_count: read_file.split(' ').count,
      byte_size: read_file.bytesize,
      file_name: File.basename(file)
    }
  end
end

main
