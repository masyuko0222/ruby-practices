require_relative './params'
require_relative './wc_file_state'

class Wc
  def main
    # 引数を受け取る
    params = Params.new(ARGV)
    # ファイルの各値を返せるクラス
    file_state = WcFileState.store_all(params)
    # 上のクラスを表示
  end
end

Wc.new.main
