file = File.open('inputs/input_day09.txt')
file_array = file.read.split("\n")

class Rope
  attr_reader :head, :part1, :part2, :part3, :part4, :part5, :part6, :part7, :part8, :tail, :visited_tail_positions

  def initialize
    @head = { x: 0, y: 0 }
    @part1 = { x: 0, y: 0 }
    @part2 = { x: 0, y: 0 }
    @part3 = { x: 0, y: 0 }
    @part4 = { x: 0, y: 0 }
    @part5 = { x: 0, y: 0 }
    @part6 = { x: 0, y: 0 }
    @part7 = { x: 0, y: 0 }
    @part8 = { x: 0, y: 0 }
    @tail = { x: 0, y: 0 }
    @visited_tail_positions = [ {x: 0, y: 0} ]
  end

  def head_tail_touching(h, t)
    ((h[:x] - t[:x]).abs <= 1) && ((h[:y] - t[:y]).abs <= 1)
  end

  def move_head(direction)
    if direction == 'R'
      @head[:x] += 1
    elsif direction == 'U'
      @head[:y] += 1
    elsif direction == 'L'
      @head[:x] -= 1
    elsif direction == 'D'
      @head[:y] -= 1
    end
  end

  def move(h, t)
    return if head_tail_touching(h, t)

    if h[:y] == t[:y]
      t[:x] += h[:x] > t[:x] ? 1 : -1
    elsif h[:x] == t[:x]
      t[:y] += h[:y] > t[:y] ? 1 : -1
    else
      t[:x] += h[:x] > t[:x] ? 1 : -1
      t[:y] += h[:y] > t[:y] ? 1 : -1
    end

    @visited_tail_positions << @tail.clone if t == @tail
  end
end


def part1(input)
  rope = Rope.new
  input.each do |line|
    dir, steps = line.split
    steps.to_i.times do
      rope.move_head(dir)
      rope.move(rope.head, rope.tail)
    end
  end
  rope.visited_tail_positions.uniq.count
end

def part2(input)
  rope = Rope.new
  input.each do |line|
    dir, steps = line.split
    steps.to_i.times do
      rope.move_head(dir)
      rope.move(rope.head, rope.part1)
      rope.move(rope.part1, rope.part2)
      rope.move(rope.part2, rope.part3)
      rope.move(rope.part3, rope.part4)
      rope.move(rope.part4, rope.part5)
      rope.move(rope.part5, rope.part6)
      rope.move(rope.part6, rope.part7)
      rope.move(rope.part7, rope.part8)
      rope.move(rope.part8, rope.tail)
    end
  end
  rope.visited_tail_positions.uniq.count
end

p "part1: #{part1(file_array)}"
p "part2: #{part2(file_array)}"

