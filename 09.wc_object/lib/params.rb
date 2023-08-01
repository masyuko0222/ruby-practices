require 'optparse'

class Params
  attr_reader :options, :file_paths

  def initialize(argv)
    opt = OptionParser.new

    options = {}
    opt.on('-l') {|v| options[:lines_opt] = v }
    opt.on('-w') {|v| options[:words_opt] = v }
    opt.on('-c') {|v| options[:byte_size_opt] = v }

    opt.parse!(argv)

    @options =
      options.empty? ? { lines_opt: true, words_opt: true, byte_size_opt: true } : options

    @file_paths = argv
  end
end
