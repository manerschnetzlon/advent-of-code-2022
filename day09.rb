file = File.open('inputs/input_day09.txt')
file_array = file.read.split("\n")

class Rope
  attr_reader :head, :tail, :visited_positions

  def initialize
    @head = { x: 0, y: 0 }
    @tail = { x: 0, y: 0 }
    @visited_positions = [ {x: 0, y: 0}]
  end

  def head_tail_touching
    ((@head[:x] - @tail[:x]).abs <= 1) && ((@head[:y] - @tail[:y]).abs <= 1)
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

  def move_tail
    return if head_tail_touching

    if @head[:y] == @tail[:y]
      @tail[:x] += @head[:x] > @tail[:x] ? 1 : -1
    elsif @head[:x] == @tail[:x]
      @tail[:y] += @head[:y] > @tail[:y] ? 1 : -1
    else
      @tail[:x] += @head[:x] > @tail[:x] ? 1 : -1
      @tail[:y] += @head[:y] > @tail[:y] ? 1 : -1
    end

    @visited_positions << @tail.clone
  end
end

rope = Rope.new

file_array.each do |line|
  dir, steps = line.split
  steps.to_i.times do 
    rope.move_head(dir)
    rope.move_tail
  end
end

p rope.visited_positions.uniq.count
