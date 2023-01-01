# frozen_string_literal: true

file = File.open('inputs/input_day21.txt')
input = file.read.split("\n").map { |line| line.split(': ') }.to_h

formula = input['root']
while /\w{4}/.match?(formula)
  formula.gsub!(/\w{4}/) { |match| "(#{input[match]})" }
end

p "part1: #{eval formula}"
