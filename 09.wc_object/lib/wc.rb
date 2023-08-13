# frozen_string_literal: true

require 'optparse'
require_relative './options'
require_relative './text'
require_relative './format'

module Wc
  def self.main
    options = Options.new(ARGV).load
    file_paths = ARGV
    texts = Text.all(file_paths)

    puts Format.new(texts, **options).render
  end
end

Wc.main
