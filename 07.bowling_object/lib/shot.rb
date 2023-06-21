#frozen_string_literal: true

class Shot
  def initialize(pin)
    @pin = pin
  end

  def convert_pin_to_integer
    return 10 if @pin == 'X'
    @pin.to_i
  end
end
