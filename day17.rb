# frozen_string_literal: true

require 'pry-byebug'
require 'set'
file = File.open('inputs/input_day17.txt')
input = file.read.split('')

class Rock
  attr_accessor :elements

  def fall
    @elements.each do |element|
      element[1] -= 1
    end
  end

  def push(direction)
    @elements.each do |element|
      direction == '<' ? element[0] -= 1 : element[0] += 1
    end
  end
end

class Rock1 < Rock
  def initialize(chamber_ground)
    up_ground = chamber_ground + 4
    @elements = [[3, up_ground],
                 [4, up_ground],
                 [5, up_ground],
                 [6, up_ground]]
  end
end

class Rock2 < Rock
  def initialize(chamber_ground)
    up_ground = chamber_ground + 4
    @elements = [[4, up_ground],
                 [3, up_ground + 1],
                 [4, up_ground + 1],
                 [5, up_ground + 1],
                 [4, up_ground + 2]]
  end
end

class Rock3 < Rock
  def initialize(chamber_ground)
    up_ground = chamber_ground + 4
    @elements = [[3, up_ground],
                 [4, up_ground],
                 [5, up_ground],
                 [5, up_ground + 1],
                 [5, up_ground + 2]]
  end
end

class Rock4 < Rock
  def initialize(chamber_ground)
    up_ground = chamber_ground + 4
    @elements = [[3, up_ground],
                 [3, up_ground + 1],
                 [3, up_ground + 2],
                 [3, up_ground + 3]]
  end
end

class Rock5 < Rock
  def initialize(chamber_ground)
    up_ground = chamber_ground + 4
    @elements = [[3, up_ground],
                 [4, up_ground],
                 [3, up_ground + 1],
                 [4, up_ground + 1]]
  end
end

class Chamber
  attr_accessor :falling_rock
  attr_reader :occupied_positions, :ground

  def initialize(size)
    @size = size
    @ground = Array.new(size, 0)
    @falling_rock = nil
    @occupied_positions = Set.new
    @occupied_positions.merge([[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [8, 0]])
  end

  def create_rock(round)
    case round % 5
    when 0
      @falling_rock = Rock5.new(@ground.max)
    when 1
      @falling_rock = Rock1.new(@ground.max)
    when 2
      @falling_rock = Rock2.new(@ground.max)
    when 3
      @falling_rock = Rock3.new(@ground.max)
    when 4
      @falling_rock = Rock4.new(@ground.max)
    end
  end

  def change_ground
    @ground.count.times do |i|
      height_elements = @falling_rock.elements.select { |x, _y| x == i }
      next if height_elements.empty?

      new_height = height_elements.max[1] + 1
      @ground[i] = new_height unless new_height < @ground[i]
    end
  end

  def touch_ground?(element)
    @occupied_positions.include?([element[0], element[1]])
  end

  def touch_wall?(element, direction)
    (direction == '<' && element[0] <= 1) ||
      (direction == '>' && element[0] >= @size - 2) ||
      (direction == '<' && @occupied_positions.include?([element[0] - 1, element[1]])) ||
      (direction == '>' && @occupied_positions.include?([element[0] + 1, element[1]]))
  end
end

class Tetris
  def initialize(chamber, input, rounds)
    @chamber = chamber
    @input = input
    @rounds = rounds
  end

  def game
    index_pushes = 0
    @rounds.times do |i|
      p i
      @chamber.falling_rock = @chamber.create_rock(i + 1)
      while @chamber.falling_rock.elements.none? { |element| @chamber.touch_ground?(element) }
        direction = @input[index_pushes]
        if @chamber.falling_rock.elements.none? { |element| @chamber.touch_wall?(element, direction) }
          @chamber.falling_rock.push(direction)
        end
        @chamber.falling_rock.fall if @chamber.falling_rock.elements.none? { |element| @chamber.touch_ground?(element) }
        index_pushes = index_pushes < @input.length - 1 ? index_pushes + 1 : 0
      end
      @chamber.falling_rock.elements.each { |element| @chamber.occupied_positions << [element[0], element[1] + 1] }
      @chamber.change_ground
    end
    display_result
  end

  def display_result
    p "part1: #{@chamber.ground.max}"
  end
end

chamber_part1 = Chamber.new(9)
tetris_part1 = Tetris.new(chamber_part1, input, 2_022)
tetris_part1.game
