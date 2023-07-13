# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/table_formatter'

class TableFormatterTest < Minitest::Test
  def test_short_format_without_options
    options = { all_files: false, reverse_in_sort: false, long_format: false }
    table_formatter = TableFormatter.new(options)

    expected_format = [
      'THIS_IS_BIG_FILE                                    loooooooooooooooooooooooooooooooooooooooongtext.txt shortfolder',
      'THIS_IS_BIG_FOLDER                                  nine                                                six',
      'aggressive_link                                     old.rb                                              ten',
      'eight                                               one                                                 this_is_small_file',
      'five                                                passive_link                                        this_is_small_folder',
      'four                                                seven                                               three',
      'loooooooooooooooooooooooooooooooooooooooongfolder   short.txt                                           two',
    ]

    assert_equal expected_format, table_formatter.format
  end

  def test_long_format_without_all_and_reverse
    options = { all_files: false, reverse_in_sort: false, long_format: true}

    table_formatter = TableFormatter.new(options)

    expected_format = [
      'total 20',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 THIS_IS_BIG_FILE',
      'drwxr-xr-x 2 masyuko0222 masyuko0222 4096 Jul 12 14:06 THIS_IS_BIG_FOLDER',
      'lrwxrwxrwx 1 masyuko0222 masyuko0222   12 Jul 12 14:07 aggressive_link -> passive_link',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 eight',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 five',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 four',
      'drwxr-xr-x 2 masyuko0222 masyuko0222 4096 Jul 12 14:06 loooooooooooooooooooooooooooooooooooooooongfolder',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 loooooooooooooooooooooooooooooooooooooooongtext.txt',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 nine',
      '-rw-r--r-- 1 masyuko0222 masyuko0222 3116 Jul 13 17:42 old.rb',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 one',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:06 passive_link',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 seven',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 short.txt',
      'drwxr-xr-x 2 masyuko0222 masyuko0222 4096 Jul 12 14:06 shortfolder',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 six',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 ten',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 this_is_small_file',
      'drwxr-xr-x 2 masyuko0222 masyuko0222 4096 Jul 12 14:06 this_is_small_folder',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 three',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 two'
    ]

    assert_equal expected_format, table_formatter.format
  end
end
