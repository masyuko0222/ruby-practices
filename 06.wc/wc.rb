# frozen_string_literal: true

require 'optparse'

def main
  options = load_option

  # 配列オブジェクトで処理を行うため、File.open(0)も配列に格納する
  input_data =
    !ARGV.empty? ? ARGV.map { |file_name| File.open(file_name) } : [File.open(0)]

  display_in_wc_format(options, input_data)
end

def load_option
  opt = OptionParser.new

  params = {}

  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }

  opt.parse!(ARGV)

  params
end

def display_in_wc_format(options, input_data)
  wc_info_list = build_wc_info_list(input_data)

  wc_info_list.each do |info|
    print_line_count(info) if options.empty? || options[:l]
    print_word_count(info) if options.empty? || options[:w]
    print_byte_size(info) if options.empty? || options[:c]
    print_file_name(info) if !ARGV.empty?
    puts
  end

  print_total(options, wc_info_list) if wc_info_list.size >= 2
end

def build_wc_info_list(input_data)
  input_data.map do |data|
    data_to_string = data.read

    wc_info = {}

    wc_info[:line_count] = data_to_string.lines.count
    wc_info[:word_count] = data_to_string.split(' ').count
    wc_info[:byte_size] = data_to_string.bytesize
    wc_info[:file_name] = File.basename(data) if !ARGV.empty?

    wc_info
  end
end

def print_line_count(info)
  print info[:line_count].to_s.rjust(4)
end

def print_word_count(info)
  print " #{info[:word_count].to_s.rjust(4)}"
end

def print_byte_size(info)
  print " #{info[:byte_size]}"
end

def print_file_name(info)
  print " #{info[:file_name]}" if !ARGV.empty?
end

def print_total(options, wc_info_list)
  total_data = build_total_data(wc_info_list)

  print total_data[:line_count].to_s.rjust(4) if options.size.zero? || options[:l]
  print " #{total_data[:word_count].to_s.rjust(4)}" if options.size.zero? || options[:w]
  print " #{total_data[:byte_size].to_s.rjust(4)}" if options.size.zero? || options[:c]
  print ' total'
end

def build_total_data(wc_info_list)
  {
    line_count: wc_info_list.sum { |info| info[:line_count] },
    word_count: wc_info_list.sum { |info| info[:word_count] },
    byte_size: wc_info_list.sum { |info| info[:byte_size] }
  }
end

main
