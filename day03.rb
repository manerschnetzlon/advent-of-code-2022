# frozen_string_literal: true

file = File.open('inputs/input_day03.txt')
file_array = file.read.split("\n")

items = file_array.map do |line|
  half = line.length / 2
  line[0...half].chars & line[half..].chars
end.flatten

items2 = file_array.each_slice(3).map do |slice|
  slice[0].chars & slice[1].chars & slice[2].chars
end.flatten

chars = ('a'..'z').to_a + ('A'..'Z').to_a
dic = chars.zip((1..chars.count).to_a).to_h

p "part1: #{items.map { dic[_1] }.sum}"
p "part2: #{items2.map { dic[_1] }.sum}"
