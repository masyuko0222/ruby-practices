# frozen_string_literal: true

require_relative './file_state'
require 'debug'

class LongFormatter
  def initialize(file_names, states_of_files)
    @file_names = file_names
    @states_of_files = states_of_files
  end

  def format
    total_block = @states_of_files.map { |state_of_file| state_of_file[:block_size] / 2 }.sum

    formatted_file_names =
      @states_of_files.map do |state_of_file|
        base_format =
          "#{state_of_file[:file_type]}" + 
          "#{state_of_file[:file_permission]}" +
          " #{state_of_file[:hardlink_count]}" +
          " #{state_of_file[:user_name]}" +
          " #{state_of_file[:group_name]}" +
          " #{state_of_file[:file_size].to_s.rjust(rjust_length_of_file_size)}" +
          " #{state_of_file[:time_stamp]}" +
          " #{state_of_file[:file_name]}"

        add_link_format(base_format, state_of_file) if state_of_file[:symlink?]

        base_format
      end

    ["total #{total_block}", *formatted_file_names]
  end

  private

  def rjust_length_of_file_size
    @states_of_files.map { |state_of_file| state_of_file[:file_size] }.max.to_s.length
  end

  def add_link_format(base_format, state_of_file)
    base_format.concat(" -> #{state_of_file[:link_to]}")
  end
end
