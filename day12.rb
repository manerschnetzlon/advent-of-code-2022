# frozen_string_literal: true

require 'set'
require 'pry-byebug'
file = File.open('inputs/input_day12.txt')
input = file.read.split("\n")

def setup(input)
  positions = {}
  input.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      positions[[x, y]] = case char
                          when 'S'
                            positions[:start] = [x, y].freeze
                            {
                              height: 'a'.ord - 1,
                              pound: 0,
                              rejected: false
                            }
                          when 'E'
                            positions[:end] = [x, y].freeze
                            {
                              height: 'z'.ord + 1,
                              pound: 0,
                              rejected: false
                            }
                          else
                            {
                              height: char.ord,
                              pound: 0,
                              rejected: false
                            }
                          end
    end
  end
  positions
end

def display(input, positions)
  input.each_with_index do |line, y|
    puts ''
    line.chars.each_with_index do |_char, x|
      to_print = positions[[x, y]][:rejected] ? 'x' : '.'
      print to_print
    end
  end
  puts ''
end

def neighbours(current, positions)
  neighbours = []
  x, y = current
  height = positions[current][:height]
  if positions.include?([x - 1, y]) && (positions[[x - 1, y]][:height] - height) <= 1 && !positions[[x - 1, y]][:rejected]
    neighbours << [x - 1, y]
  end
  if positions.include?([x + 1, y]) && (positions[[x + 1, y]][:height] - height) <= 1 && !positions[[x + 1, y]][:rejected]
    neighbours << [x + 1, y]
  end
  if positions.include?([x, y - 1]) && (positions[[x, y - 1]][:height] - height) <= 1 && !positions[[x, y - 1]][:rejected]
    neighbours << [x, y - 1]
  end
  if positions.include?([x, y + 1]) && (positions[[x, y + 1]][:height] - height) <= 1 && !positions[[x, y + 1]][:rejected]
    neighbours << [x, y + 1]
  end
  neighbours
end

def find_path(current, input)
  visited = Set.new
  positions = setup(input)

  loop do
    # display(input, positions)
    neighbours(current, positions).each do |n|
      positions[n][:pound] = positions[current][:pound] + 1
      visited << n
    end
    positions[current][:rejected] = true
    visited.delete(current)
    current = visited.min { |a, b| positions[a][:pound] <=> positions[b][:pound] }
    return positions[current][:pound] if current == positions[:end]
  end
end

start = setup(input)[:start]
p "part1: #{find_path(start, input)}"

steps = []
input.count.times do |y|
  steps << find_path([0, y], input)
end
p "part2: #{steps.min}"
