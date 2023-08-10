# frozen_string_literal: true

require 'optparse'

class Options
  def initialize(argv)
    @argv = argv
  end

  def load
    opt = OptionParser.new

    tmp_options = { show_lines: false, show_words: false, show_byte_size: false }
    opt.on('-l') {|v| tmp_options[:show_lines] = v }
    opt.on('-w') {|v| tmp_options[:show_words] = v }
    opt.on('-c') {|v| tmp_options[:show_bytesize] = v }
    opt.parse!(@argv)

    options = tmp_options.values.none? ? tmp_options.transform_values { |v| v = true } : tmp_options
    options
  end
end
