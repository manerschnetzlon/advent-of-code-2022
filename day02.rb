file = File.open('inputs/input_day02.txt')
file_array = file.read.split('\n')

scores_part1 = {
  'A' => {
    'X' => 4,
    'Y' => 8,
    'Z' => 3
  },
  'B' => {
    'X' => 1,
    'Y' => 5,
    'Z' => 9
  },
  'C' => {
    'X' => 7,
    'Y' => 2,
    'Z' => 6
  }
}

scores_part2 = {
  'A' => {
    'X' => 3,
    'Y' => 4,
    'Z' => 8
  },
  'B' => {
    'X' => 1,
    'Y' => 5,
    'Z' => 9
  },
  'C' => {
    'X' => 2,
    'Y' => 6,
    'Z' => 7
  }
}

results_part1 = file_array.map(&:split).map do |k, v|
  scores_part1[k][v]
end
p results_part1.sum

results_part2 = file_array.map(&:split).map do |k, v|
  scores_part2[k][v]
end
p results_part2.sum
