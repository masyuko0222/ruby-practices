# frozen_string_literal: true

require 'optparse'

def main
  options = load_options

  options =
    options.empty? ? { l: true, w: true, c: true } : options

  # 配列オブジェクトで処理を行うため、File.open(0)も配列に格納する
  input_data =
    ARGV.empty? ? [File.open(0)] : ARGV.map { |file_name| File.open(file_name) }

  display_wc(input_data, line_counts: options[:l], word_counts: options[:w], byte_size: options[:c])
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

def display_wc(input_data, line_counts: false, word_counts: false, byte_size: false)
  wc_counts_list = build_wc_counts_list(input_data)

  wc_counts_list.each do |counts|
    print counts[:line_count].to_s.rjust(4) if line_counts
    print " #{counts[:word_count].to_s.rjust(4)}" if word_counts
    print " #{counts[:byte_size].to_s.rjust(4)}" if byte_size
    print " #{counts[:file_name]}" if ARGV.size.positive?
    puts
  end

  display_total_counts(wc_counts_list, line_counts, word_counts, byte_size) if input_data.size >= 2
end

def build_wc_counts_list(input_data)
  input_data.map do |data|
    # File.readは、ファイル(標準入力)内のテキストを丸々Stringオブジェクトとして返す。\nのような改行文字も含む。
    read_content_string = data.read

    wc_info = {}

    wc_info[:line_count] = data_to_string.lines.count
    wc_info[:word_count] = data_to_string.split(' ').count
    wc_info[:byte_size] = data_to_string.bytesize

    # 標準入力を利用する場合、File.basenameが取得できないため、空のハッシュを作ってから、条件分岐でFile.basenameを格納する処理にしました
    wc_info[:file_name] = File.basename(data) if ARGV.size.positive?

    wc_info
  end
end

def display_total_counts(wc_counts_list, line_counts, word_counts, byte_size)
  total_counts_list = build_total_counts_list(wc_counts_list)

  print total_counts_list[:line_count].to_s.rjust(4) if line_counts
  print " #{total_counts_list[:word_count].to_s.rjust(4)}" if word_counts
  print " #{total_counts_list[:byte_size].to_s.rjust(4)}" if byte_size
  print ' total'
end

def build_total_counts_list(wc_counts_list)
  {
    line_count: wc_counts_list.sum { |info| info[:line_count] },
    word_count: wc_counts_list.sum { |info| info[:word_count] },
    byte_size: wc_counts_list.sum { |info| info[:byte_size] }
  }
end

main
