# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/single_file_format'
require_relative '../lib/wc_file'
require_relative '../lib/params'

class SingleFileFormatTest < Minitest::Test
  def setup
    @params = Params.new(ARGV)
  end

  def test_render_with_all_options
    options = { lines_count: true, words_count: true, byte_size: true }
    paths = ['test/fixtures/1_1_7_wc.txt']

    wc_files = WcFile.all(paths)

    assert_equal '1 1 7 test/fixtures/1_1_7_wc.txt', SingleFileFormat.new(wc_files, **options).render
  end

  def test_render_diffrent_digits
    options = { lines_count: true, words_count: true, byte_size: true }
    paths = ['test/fixtures/20_60_374_wc.txt']

    wc_files = WcFile.all(paths)

    assert_equal ' 20  60 374 test/fixtures/20_60_374_wc.txt', SingleFileFormat.new(wc_files, **options).render
  end
end
