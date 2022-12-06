# frozen_string_literal: true

signal = File.open('inputs/input_day06.txt').read

def find_marker(signal, marker_length)
  received = []
  signal.chars do |c|
    received << c
    break if received.last(marker_length).uniq.count == marker_length
  end
  received.count
end

p "part1: #{find_marker(signal, 4)}"
p "part1: #{find_marker(signal, 14)}"
