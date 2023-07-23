# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../lib/long_formatter'
require_relative '../lib/directory'
require_relative '../lib/file_state'

class LongFormatterTest < Minitest::Test
  def test_format_no_args
    file_names = Directory.new.load_file_names
    long_formatter = LongFormatter.new(file_names)

    expected_format = [
      'total 20',
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
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 THIS_IS_BIG_FILE',
      'drwxr-xr-x 2 masyuko0222 masyuko0222 4096 Jul 12 14:06 THIS_IS_BIG_FOLDER',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 this_is_small_file',
      'drwxr-xr-x 2 masyuko0222 masyuko0222 4096 Jul 12 14:06 this_is_small_folder',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 three',
      '-rw-r--r-- 1 masyuko0222 masyuko0222    0 Jul 12 14:05 two'
    ]

    assert_equal expected_format, long_formatter.format
  end
end
