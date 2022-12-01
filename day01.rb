file = File.open('inputs/input_day01.txt')
file_array = file.read.split("\n\n")

p file_array.map { _1.split("\n").map(&:to_i).sum }.max(3).sum
