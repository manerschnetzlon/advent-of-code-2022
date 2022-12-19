# frozen_string_literal: true

require 'set'
file = File.open('inputs/input_day18.txt')
file_array = file.read.split("\n").map { |line| line.split(',').map(&:to_i) }

class Cube
  attr_accessor :visible_faces, :exterior, :neigbors
  attr_reader :x, :y, :z, :type

  def initialize(x, y, z, type)
    @x = x
    @y = y
    @z = z
    @neigbors = Set.new
    @visible_faces = 0
    @exterior = false
    @type = type
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
    @cubes = Set.new
    @air_cubes = Set.new
  end

  def scan
    @input.each { |cube| @cubes << Cube.new(cube[0], cube[1], cube[2], 'lava') }
    p "part1: #{count_visible_faces}"
  end

  def count_visible_faces
    @cubes.each do |cube|
      other_cubes = @cubes.reject { |c| c == cube }
      other_cubes.each do |other_cube|
        cube.neigbors << other_cube if cube.neighbor?(other_cube)
      end
      cube.visible_faces = 6 - cube.neigbors.count
    end
    @cubes.map(&:visible_faces).sum
  end
end

scanner = Scanner.new(file_array)
scanner.scan
