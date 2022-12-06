# frozen_string_literal: true

file = File.open('inputs/input_day05.txt')
file_array = file.read.split("\n")
instructions = file_array.map do |i|
  i.scan(/\d+/).map(&:to_i)
end

queues = [
  %w[H R B D Z F L S],
  %w[T B M Z R],
  %w[Z L C H N S],
  %w[S C F J],
  %w[P G H W R Z B],
  %w[V J Z G D N M T],
  %w[G L N W F S P Q],
  %w[M Z R],
  %w[M C L G V R T]
]

def move_stacks_part1(instructions, queues)
  instructions.each do |instruction|
    instruction[0].times { queues[instruction[2] - 1] << queues[instruction[1] - 1].pop }
  end
  queues
end

def move_stacks_part2(instructions, queues)
  instructions.each do |instruction|
    queues[instruction[2] - 1] << queues[instruction[1] - 1].slice!(-instruction[0]..)
    queues[instruction[2] - 1].flatten!
  end
  queues
end

print 'part1: '
move_stacks_part1(instructions, queues).each { print _1.last }
print "\npart2: "
move_stacks_part2(instructions, queues).each { print _1.last }
