# frozen_string_literal: true

require 'json'

file = File.open('inputs/input_day13.txt')
file_array = file.read.split("\n\n")

def valid?(left, right)
  return nil if left.empty? && right.empty?
  return true if left.empty?
  return false if right.empty?

  l_head, *l_tail = left
  r_head, *r_tail = right

  if l_head.is_a?(Integer) && r_head.is_a?(Integer)
    return true if l_head < r_head
    return false if l_head > r_head
  elsif l_head.is_a?(Array) && r_head.is_a?(Array)
    result = valid?(l_head, r_head)
  else
    tmp_l_head = l_head.is_a?(Integer) ? [l_head] : l_head
    tmp_r_head = r_head.is_a?(Integer) ? [r_head] : r_head
    result = valid?(tmp_l_head, tmp_r_head)
  end

  result.nil? ? valid?(l_tail, r_tail) : result
end

pairs = file_array
        .map { |bloc| bloc.split("\n") }
        .map { |packet| packet.map { JSON.parse(_1) } }

part1 = pairs.map.with_index { |pair, index| valid?(pair[0], pair[1]) ? index + 1 : 0 }.sum
p "part1: #{part1}"

all = [[[2]], [[6]]]
pairs.each { |pair| pair.each { |p| all << p } }

i = 0
while i != all.length - 1
  tmp = []
  if valid?(all[i], all[i + 1])
    i += 1
  else
    tmp = all[i]
    all[i] = all[i + 1]
    all[i + 1] = tmp
    i = 0
  end
end

p "part1: #{(all.find_index([[2]]) + 1) * (all.find_index([[6]]) + 1)}"
