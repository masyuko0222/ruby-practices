# frozen_string_literal: true

COLUMN = 3

def main
  ready_files_to_display.each do |files|
    files.each do |file|
      print file.ljust(count_filname_char + 1) if file
    end
    print "\n"
  end
end

def load_files
  Dir.entries('.').sort.grep_v(/^\./)
end

def count_filname_char
  load_files.max_by(&:length).length
end

def ready_files_to_display
  non_dot_files = load_files

  line_length = (non_dot_files.size.to_f / COLUMN).ceil

  non_dot_files << nil until (non_dot_files.size % line_length).zero?

  non_dot_files.each_slice(line_length).to_a.transpose
end

main
