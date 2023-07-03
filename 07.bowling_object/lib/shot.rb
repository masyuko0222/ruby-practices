# frozen_string_literal:true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if @mark == 'X'
    return nil if @mark == nil # nilからto_iを呼び出すと0に変換されてしまうため、明示的にnilを返すように

    @mark.to_i
  end
end
