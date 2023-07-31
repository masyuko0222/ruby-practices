# frozen_string_literal:true

require "optparse"

class Params
  attr_reader :paths, :options

  def initialize(argv)
    opt = OptionParser.new

    tmp_options = {}
    opt.on('-l') { |v| @options[:lines_count] = true }
    opt.on('-w') { |v| @options[:words_count] = true }
    opt.on('-c') { |v| @options[:byte_size] = true }

    @paths = opt.parse!(argv)
    @options = tmp_options.empty? ? { line_count: true, words_count: true, byte_size: true } : tmp_options
  end
end
