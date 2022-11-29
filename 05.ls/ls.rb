# frozen_string_literal: true

COLUMN_LENGTH = 3

def main
  files = load_files

  max_filename_length = files.max_by(&:length).length
  file_table = build_file_table(files)

  file_table.each do |files|
    files.each do |file|
      print file.ljust(max_filename_length + 1) if file
    end
    print "\n"
  end
end

def load_files
  Dir.entries('.').sort.grep_v(/^\./)
end

def build_file_table(files)
  line_length = (files.size.to_f / COLUMN_LENGTH).ceil

  adding_nil_count = line_length * COLUMN_LENGTH - files.size
  files += Array.new(adding_nil_count)

  files.each_slice(line_length).to_a.transpose
end

main
