# frozen_string_literal: true

file = File.open('inputs/input_day16.txt')
file_array = file.read.split("\n")

VALVES = {}
PATHS = {}

file_array.each do |line|
  regex = /Valve (?<current>\w+) has flow rate=(?<pressure>\d+); tunnels? leads? to valves? (?<next_valves>.+)/
  matches = regex.match(line)
  VALVES[matches[:current]] = matches[:pressure].to_i
  PATHS[matches[:current]] = matches[:next_valves].split(', ')
end

CACHE = {}

def max_pressure(current_valve, opened_valves, time, is_elephant)
  if time <= 0
    return 0 unless is_elephant

    return max_pressure('AA', opened_valves, 26, !is_elephant)
  end

  key = [current_valve, opened_valves.sort, time, is_elephant]
  return CACHE[key] if CACHE.key?(key)

  max = 0
  unless opened_valves.include?(current_valve) || VALVES[current_valve].zero?
    current_opened_valves = opened_valves + [current_valve]
    pressure = VALVES[current_valve] * (time - 1)
    current_max = pressure + max_pressure(current_valve, current_opened_valves, time - 1, is_elephant)
    max = current_max if current_max > max
  end

  PATHS[current_valve].each do |next_valve|
    current_max = max_pressure(next_valve, opened_valves, time - 1, is_elephant)
    max = current_max if current_max > max
  end

  CACHE[key] = max
  max
end

p "part1: #{max_pressure('AA', [], 30, false)}"
p "part2: #{max_pressure('AA', [], 26, true)}"
