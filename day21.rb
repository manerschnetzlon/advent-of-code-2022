# frozen_string_literal: true

file = File.open('inputs/input_day21.txt')
file_array = file.read.split("\n")

def part1(input)
  formula = input['root']
  while /\w{4}/.match?(formula)
    formula.gsub!(/\w{4}/) { |match| "(#{input[match]})" }
  end
  formula
end

def part2(input)
  formula = input['root'].gsub!('+', '==')
  while /\w{4}/.match?(formula)
    formula.gsub!(/\w{4}/) { |match| "(#{input[match]})" }
  end
  new_formula = formula.split(' == ').map { |f| f.include?('h') ? f : (eval f) }
  new_formula.partition { |f| f.instance_of?(String) }.map(&:first)
end

input = file_array.map { |line| line.split(': ') }.to_h
p "part1: #{eval part1(input)}"

input2 = file_array.map { |line| line.gsub('humn', 'h').split(': ') }.to_h
p "part2: #{part2(input2).join(' = ')}" # use online equation solver
