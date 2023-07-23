# frozen_string_literal: true

require_relative './file_state'

class LongFormatter
  def initialize(file_names)
    @file_names = file_names
  end

  def format
    states_of_files = load_states_of_files
    total_block = states_of_files.map { |state_of_file| state_of_file[:block_size] / 2 }.sum
    rjust_length = states_of_files.map { |state_of_file| state_of_file[:file_size] }.max.to_s.length

    formatted_file_names =
      states_of_files.map do |state_of_file|
        base_format =
          state_of_file[:file_type].to_s +
          state_of_file[:file_permission] +
          " #{state_of_file[:hardlink_count]}" \
          " #{state_of_file[:user_name]}" \
          " #{state_of_file[:group_name]}" \
          " #{state_of_file[:file_size].to_s.rjust(rjust_length)}" \
          " #{state_of_file[:time_stamp]}" \
          " #{state_of_file[:file_name]}"

        add_link(base_format, state_of_file) if state_of_file[:symlink?]

        base_format
      end

    ["total #{total_block}", *formatted_file_names]
  end

  private

  def load_states_of_files
    @file_names.map { |file_name| FileState.new(file_name).load_for_long_format }
  end

  def add_link(base_format, state_of_file)
    base_format.concat(" -> #{state_of_file[:link_to]}")
  end
end
