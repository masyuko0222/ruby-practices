# frozen_string_literal: true

# 表示するファイルと列数は、メソッドで処理を行う前に決められるので、トップレベルで定義。
FILES_NO_DOT = Dir.entries('.').sort.grep_v(/^\./)
COLUMNS = 3

def save_files_horizontally
  # transpose前は3行表示になるように分割(transpose後に3列表示になるために)
  lines = (FILES_NO_DOT.size % COLUMNS).zero? ? (FILES_NO_DOT.size / COLUMNS) : (FILES_NO_DOT.size / COLUMNS) + 1
  files_horizontally = FILES_NO_DOT.each_slice(lines).to_a

  # 各配列の要素数が一致していない場合、nilを追加して要素数を全て揃える
  max_elements = files_horizontally.max_by(&:size).size
  files_horizontally.each do |arr|
    arr << nil while arr.size < max_elements
  end

  files_horizontally
end

def display_files_vertically
  files_vertically = save_files_horizontally.transpose.each do |arr|
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

display_files_vertically
