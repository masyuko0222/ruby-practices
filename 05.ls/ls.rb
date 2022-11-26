# frozen_string_literal: true

COLUMN_LENGTH = 3

def main
  # mainメソッド内だけでも、どんな種類のファイルかを一目で分かりやすくしたいため、このように命名しました。
  no_dot_files = load_files

  max_filename_length = count_length_filename(no_dot_files)
  transposed_files = transpose_files(no_dot_files)

  transposed_files.each do |files|
    files.each do |file|
      print file.ljust(max_filename_length + 1) if file
    end
    print "\n"
  end
end

def load_files
  Dir.entries('.').sort.grep_v(/^\./)
end

def count_length_filename(files)
  files.max_by(&:length).length
end

def transpose_files(files)
  line_length = (files.size.to_f / COLUMN_LENGTH).ceil

  nil_adding_count = line_length * COLUMN_LENGTH - files.size
  nil_adding_count.times { files << nil }

  files.each_slice(line_length).to_a.transpose
end

main
