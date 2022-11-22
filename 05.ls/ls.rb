# frozen_string_literal: true

# 表示する列数は仕様段階で決まるので、定数として定義しました。
COLUMNS = 3

def main
  # mainメソッド実行時にnilが表示されないように、transpose後にnilの削除も一緒に行っています。
  after_transposing_files = ready_files_to_transpose.transpose.each do |files|
    files.delete(nil)
  end

  after_transposing_files.each do |files|
    files.each do |file|
      print file.ljust(@filname_max_char + 1)
    end
    print "\n"
  end
end

def ready_files_to_transpose
  non_dot_files = Dir.entries('.').sort.grep_v(/^\./)

  # この変数を利用するのはmainメソッド内のため、インスタンス変数として定義しています。
  @filname_max_char = non_dot_files.max_by(&:length).length

  line = (non_dot_files.size.to_f / COLUMNS).ceil

  non_dot_files << nil until (non_dot_files.size % line).zero?
  non_dot_files.each_slice(line).to_a
end

main
