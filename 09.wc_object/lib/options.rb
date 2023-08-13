# frozen_string_literal: true

require 'optparse'

class Options
  def initialize(argv)
    @argv = argv
  end

  def load
    opt = OptionParser.new

    options = { show_lines: false, show_words: false, show_bytesize: false }
    opt.on('-l') { |v| options[:show_lines] = v }
    opt.on('-w') { |v| options[:show_words] = v }
    opt.on('-c') { |v| options[:show_bytesize] = v }
    opt.parse!(@argv)

    options.values.none? ? options.transform_values { true } : options
  end
end
