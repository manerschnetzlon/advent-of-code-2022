# frozen_string_literal: true
require 'set'

file = File.open('inputs/input_day14.txt')
file_array = file.read.split("\n").map { |line| line.split(' -> ').map { |path| path.split(',').map(&:to_i) } }

def structure(input)
  rocks = Set.new

  input.each do |line|
    line.each_cons(2) do |l_start, l_end|
      if l_start[0] > l_end[0]
        x_start = l_end[0]
        x_end = l_start[0]
      else
        x_start = l_start[0]
        x_end = l_end[0]
      end

      if l_start[1] > l_end[1]
        y_start = l_end[1]
        y_end = l_start[1]
      else
        y_start = l_start[1]
        y_end = l_end[1]
      end

      (y_start..y_end).each { |y| rocks << [l_start[0], y] } if l_start[0] == l_end[0]
      (x_start..x_end).each { |x| rocks << [x, l_start[1]] } if l_start[1] == l_end[1]
    end
  end
  rocks
end

def ground(structure)
  structure.max { |a, b| a[1] <=> b[1] }[1]
end

def can_down(sand, structure, ground)
  !structure.include?([sand[0], sand[1] + 1]) && sand[1] + 1 < ground
end

def can_down_left(sand, structure, ground)
  !structure.include?([sand[0] - 1, sand[1] + 1]) && sand[1] + 1 < ground
end

def can_down_right(sand, structure, ground)
  !structure.include?([sand[0] + 1, sand[1] + 1]) && sand[1] + 1 < ground
end

# def down(sand, structure)
#   structure << [sand[0], sand[1] + 1]
# end

# def down_left(sand, structure)
#   structure << [sand[0] - 1, sand[1] + 1]
# end

# def down_right(sand, structure)
#   structure << [sand[0] + 1, sand[1] + 1]
# end

# def stay(sand, structure)
#   structure << sand
# end

def pouring_sand(structure)
  # ground = ground(structure) #part1
  ground = ground(structure) + 2 #part2

  i = 0
  loop do
    sand = [500, 0]
    loop do
      if can_down(sand, structure, ground)
        sand[1] += 1
      elsif can_down_left(sand, structure, ground)
        sand[0] -= 1
        sand[1] += 1
      elsif can_down_right(sand, structure, ground)
        sand[0] += 1
        sand[1] += 1
      else
        structure << sand
        break
      end
    end
    i += 1

    break if sand == [500, 0]
  end
  i
end

structure = structure(file_array)
p "part2: #{pouring_sand(structure)}"
