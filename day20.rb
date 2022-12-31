# frozen_string_literal: true

file = File.open('inputs/input_day20.txt')
file_array = file.read.split("\n").map(&:to_i)

def decrypt(list)
  list.length.times do |i|
    list.rotate! until list.first[1] == i
    head, *tail = list
    tail.rotate!(head[0])
    tail.unshift(head)
    list = tail.rotate!(-head[0])
  end
  list.rotate! until list.first[0] == 0
  list.map(&:first)
end

def find_at_index(index, list)
  length = list.length
  while index >= length
    index -= length
  end
  list[index]
end

list = file_array.map.with_index { |num, index| [num, index] }
decrypted_list = decrypt(list)
p find_at_index(1000, decrypted_list) + find_at_index(2000, decrypted_list) + find_at_index(3000, decrypted_list)
