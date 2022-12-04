# frozen_string_literal: true

file = File.open('inputs/input_day04.txt')
file_array = file.read.split("\n")

ranges = file_array.map { _1.split(',') }

overlaps_part1 = ranges.select do |range|
  parts = range.map { _1.split('-') }
  (parts[0][0].to_i <= parts[1][0].to_i && parts[0][1].to_i >= parts[1][1].to_i) ||
    (parts[0][0].to_i >= parts[1][0].to_i && parts[0][1].to_i <= parts[1][1].to_i)
end

overlaps_part2 = ranges.reject do |range|
  parts = range.map { _1.split('-') }
  (((parts[0][0].to_i)..(parts[0][1].to_i)).to_a & ((parts[1][0].to_i)..(parts[1][1].to_i)).to_a).empty?
end

p "part1: #{overlaps_part1.count}"
p "part2: #{overlaps_part2.count}"
