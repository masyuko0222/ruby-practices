# frozen_string_literal: true

require 'optparse'

def main
  # options.parse!後にARGVを取得したいため、先にload_optionsメソッドを実行しています
  options = load_options

  # 配列オブジェクトで処理を行うため、File.open(0)も配列に格納する
  input_data =
    ARGV.empty? ? [File.open(0)] : ARGV.map { |file_name| File.open(file_name) }

  display_wc(input_data, options)
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

def display_wc(input_data, options)
  wc_counts_list = build_wc_counts_list(input_data)

  options.empty? ? print_all_counts(wc_counts_list) : print_specified_counts(wc_counts_list, options)

  print_total(wc_counts_list, options) if wc_counts_list.size >= 2
end

def build_wc_counts_list(input_data)
  input_data.map do |data|
    # File.readは、ファイル(標準入力)内のテキストを丸々Stringオブジェクトとして返す。\nのような改行文字も含む。
    data_to_string = data.read

    wc_info = {}

    wc_info[:line_count] = data_to_string.lines.count
    wc_info[:word_count] = data_to_string.split(' ').count
    wc_info[:byte_size] = data_to_string.bytesize

    # 標準入力を利用する場合、File.basenameが取得できないため、空のハッシュを作ってから、条件分岐でFile.basenameを格納する処理にしました
    wc_info[:file_name] = File.basename(data) if ARGV.size.positive?

    wc_info
  end
end

def print_all_counts(wc_counts_list)
  wc_counts_list.each do |counts|
    print counts[:line_count].to_s.rjust(4)
    print " #{counts[:word_count].to_s.rjust(4)}"
    print " #{counts[:byte_size].to_s.rjust(4)}"
    print " #{counts[:file_name]}" if ARGV.size.positive?
    puts
  end
end

def print_specified_counts(wc_counts_list, options)
  wc_counts_list.each do |counts|
    print counts[:line_count].to_s.rjust(4) if options[:l]
    print " #{counts[:word_count].to_s.rjust(4)}" if options[:w]
    print " #{counts[:byte_size].to_s.rjust(4)}" if options[:c]
    print " #{counts[:file_name]}" if ARGV.size.positive?
    puts
  end
end

def print_total(wc_counts_list, options)
  total_counts_list = build_total_counts_list(wc_counts_list)

  print total_counts_list[:line_count].to_s.rjust(4) if options.empty? || options[:l]
  print " #{total_counts_list[:word_count].to_s.rjust(4)}" if options.empty? || options[:w]
  print " #{total_counts_list[:byte_size].to_s.rjust(4)}" if options.empty? || options[:c]
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
