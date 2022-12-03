# frozen_string_literal: true

file = File.open('inputs/input_day02.txt')
file_array = file.read.split("\n")

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

def compute_score(input, dic)
  input.map(&:split).map do |k, v|
    dic[k][v]
  end.sum
end

p "part1: #{compute_score(file_array, scores_part1)}"
p "part2: #{compute_score(file_array, scores_part2)}"
