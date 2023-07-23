# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/short_formatter'
require_relative '../lib/directory'

class ShortFormatterTest < Minitest::Test
  def test_format_no_args
    directory = Directory.new
    file_names = directory.load_file_names
    short_formatter = ShortFormatter.new(file_names)

    expected_format = [
      'aggressive_link                                     old.rb                                              ten',
      'eight                                               one                                                 THIS_IS_BIG_FILE',
      'five                                                passive_link                                        THIS_IS_BIG_FOLDER',
      'four                                                seven                                               this_is_small_file',
      'loooooooooooooooooooooooooooooooooooooooongfolder   short.txt                                           this_is_small_folder',
      'loooooooooooooooooooooooooooooooooooooooongtext.txt shortfolder                                         three',
      'nine                                                six                                                 two'
    ]

    assert_equal expected_format, short_formatter.format
  end

  def test_format_reverse_option
    directory = Directory.new(reverse_in_sort: true)
    file_names = directory.load_file_names
    short_formatter = ShortFormatter.new(file_names)

    expected_format = [
      'two                                                 six                                                 nine',
      'three                                               shortfolder                                         loooooooooooooooooooooooooooooooooooooooongtext.txt',
      'this_is_small_folder                                short.txt                                           loooooooooooooooooooooooooooooooooooooooongfolder',
      'this_is_small_file                                  seven                                               four',
      'THIS_IS_BIG_FOLDER                                  passive_link                                        five',
      'THIS_IS_BIG_FILE                                    one                                                 eight',
      'ten                                                 old.rb                                              aggressive_link'
    ]

    assert_equal expected_format, short_formatter.format
  end
end
