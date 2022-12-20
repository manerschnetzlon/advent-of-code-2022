# frozen_string_literal: true

require 'set'
require 'pry-byebug'
file = File.open('inputs/input_day18.txt')
file_array = file.read.split("\n").map { |line| line.split(',').map(&:to_i) }

class Cube
  attr_accessor :visible_faces, :exterior, :neigbors, :checked
  attr_reader :x, :y, :z, :type

  def initialize(x, y, z, type)
    @x = x
    @y = y
    @z = z
    @neigbors = Set.new
    @visible_faces = 0
    @exterior = false
    @type = type
    @checked = false
  end

  def neighbor?(other_cube)
    (@x == other_cube.x && @y == other_cube.y && (@z - other_cube.z).abs == 1) ||
      ((@x - other_cube.x).abs == 1 && @y == other_cube.y && @z == other_cube.z) ||
      (@x == other_cube.x && (@y - other_cube.y).abs == 1 && @z == other_cube.z)
  end
end

class Scanner
  def initialize(input)
    @input = input
    @lava_cubes = Set.new
    @air_cubes = Set.new
  end

  def scan
    @input.each { |cube| @lava_cubes << Cube.new(cube[0], cube[1], cube[2], 'lava') }
    p "part1: #{part1}"
    p "part2: #{part2}"
  end

  def part1
    @lava_cubes.each do |cube|
      cube.neigbors = []
      @lava_cubes.each do |other_cube|
        cube.neigbors << other_cube if cube.neighbor?(other_cube)
      end
      cube.visible_faces = 6 - cube.neigbors.count
    end
    @lava_cubes.map(&:visible_faces).sum
  end

  def part2
    create_air_cubes
    all_cubes = @lava_cubes + @air_cubes
    all_cubes.each do |cube|
      cube.neigbors = []
      all_cubes.each do |other_cube|
        cube.neigbors << other_cube if cube.neighbor?(other_cube)
      end
      cube.exterior = true if cube.neigbors.count != 6
    end

    queue = []
    @air_cubes.select(&:exterior).each { |c| queue << c }

    until queue.empty?
      c = queue.pop
      c.exterior = true
      c.checked = true
      c.neigbors.each { |n| queue << n unless n.checked || c.type == 'lava' }
    end

    @air_cubes.select(&:exterior).each do |cube|
      cube.neigbors = []
      @lava_cubes.each do |other_cube|
        cube.neigbors << other_cube if cube.neighbor?(other_cube)
      end
    end
    @air_cubes.select(&:exterior).map { |c| c.neigbors.count }.sum
  end

  def create_air_cubes
    x_min = @lava_cubes.map(&:x).min - 1
    x_max = @lava_cubes.map(&:x).max + 1
    y_min = @lava_cubes.map(&:y).min - 1
    y_max = @lava_cubes.map(&:y).max + 1
    z_min = @lava_cubes.map(&:z).min - 1
    z_max = @lava_cubes.map(&:z).max + 1

    (x_min..x_max).each do |x|
      (y_min..y_max).each do |y|
        (z_min..z_max).each do |z|
          next unless @lava_cubes.select { |cube| cube.x == x && cube.y == y && cube.z == z }.empty?

          new_cube = Cube.new(x, y, z, 'air')
          new_cube.exterior = true if x == x_min || x == x_max || y == y_min || y == y_max || z == z_min || z == z_max
          @air_cubes << new_cube
        end
      end
    end
  end
end

scanner = Scanner.new(file_array)
scanner.scan
