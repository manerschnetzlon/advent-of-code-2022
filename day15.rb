# frozen_string_literal: true

require 'set'
file = File.open('inputs/input_day15.txt')
file_array = file.read.split("\n")

def distance(point_a, point_b)
  (point_a[0] - point_b[0]).abs + (point_a[1] - point_b[1]).abs
end

sensors = Set.new
beacons = Set.new

file_array.map { |line| line.scan(/-?\d+/).map(&:to_i) }
          .map do |coord|
            sensor = coord[0..1]
            beacon = coord[2..]
            sensors << [sensor, distance(sensor, beacon)]
            beacons << beacon
          end

excluded_positions = Set.new
(-10_000_000..10_000_000).each do |x|
  point = [x, 2_000_000]
  sensors.each do |position, distance|
    excluded_positions << point if distance(position, point) <= distance && !beacons.include?(point)
  end
end
p "part1: #{excluded_positions.count}"
