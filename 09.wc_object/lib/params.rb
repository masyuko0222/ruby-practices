require 'optparse'
require 'debug'

class Params
  attr_reader :target_paths

  def initialize(argv)
    opt = OptionParser.new

    tmp_params = {}
    opt.on('-l') { |v| tmp_params[:l] = v }
    opt.on('-w') { |v| tmp_params[:w] = v }
    opt.on('-c') { |v| tmp_params[:c] = v }

    @target_paths = opt.parse!(ARGV)
    @params = tmp_params.empty? ? { l: true, w: true, c:true } : tmp_params
  end

  def show_lines?
    !!@params[:l]
  end

  def show_words?
    !!@params[:w]
  end

  def show_bytes?
    !!@params[:c]
  end
end
