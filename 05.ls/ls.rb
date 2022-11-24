# frozen_string_literal: true

COLUMN_LENGTH = 3

def main
  max_filename_char_length = count_filename_char

  prepare_files_to_display.each do |files|
    files.each do |file|
      print file.ljust(max_filename_char_length + 1) if file
    end
    print "\n"
  end
end

def load_files
  Dir.entries('.').sort.grep_v(/^\./)
end

def count_filename_char
  load_files.max_by(&:length).length
end

def prepare_files_to_display
  non_dot_files = load_files

  line_length = (non_dot_files.size.to_f / COLUMN_LENGTH).ceil

  non_dot_files << nil until (non_dot_files.size % line_length).zero?

  non_dot_files.each_slice(line_length).to_a.transpose
end

main
