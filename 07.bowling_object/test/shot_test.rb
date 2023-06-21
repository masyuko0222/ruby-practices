#frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shot'

class ShotTest < Minitest::Test
  def test_pin_is_X
    shot = Shot.new('X')

    assert_equal 10, shot.convert_pin_to_integer
  end

  def test_pin_is_0
    shot = Shot.new('0')

    assert_equal 0, shot.convert_pin_to_integer
  end

  def test_pin_is_7
    shot = Shot.new('7')

    assert_equal 7, shot.convert_pin_to_integer
  end
end
