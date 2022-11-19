# frozen_string_literal: true

def set_files_horizontally
  files_no_dot = Dir.entries('.').sort.grep_v(/^\./)

  # 最大列数を定義
  max_rows = 3

  # (例) files_no_dot (12), max_rows(3) => (4)(4)(4)の要素数を持った配列にslice
  # (例) files_no_dot (13), max_rows(3) => (5)(5)(3)の要素数を持った配列にslice
  lines = (files_no_dot.size % max_rows).zero? ? (files_no_dot.size / max_rows) : (files_no_dot.size / max_rows) + 1
  files_horizontally = files_no_dot.each_slice(lines).to_a

  # 各配列の要素数が一致していない場合、nilを追加して要素数を全て揃える
  max_elements = files_horizontally.max_by(&:size).size
  files_horizontally.each do |arr|
    arr << nil while arr.size < max_elements
  end

  files_horizontally
end

def ls_command
  files_vertically = set_files_horizontally.transpose.each do |arr|
    arr.delete(nil)
  end

  max_chars_filename = files_vertically.flatten.max_by(&:length).length
  files_vertically.each do |arr|
    arr.each do |file|
      # どれだけ長いファイル名でも、綺麗に表示できるようにする
      print file.ljust(max_chars_filename + 1)
    end
    print "\n"
  end
end

ls_command
