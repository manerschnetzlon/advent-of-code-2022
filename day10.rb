file = File.open('inputs/input_day10.txt')
file_array = file.read.split("\n")

x = 1
cycle = 0
crt = []
crt_row = Array.new(40, '.')
sprite_position = [0, 1 , 2]

file_array.map(&:split).each do |cmd, value|
  t = cmd == 'addx' ? 2 : 1
  t.times do 
    crt_row[cycle] = "#" if sprite_position.include?(cycle)
    cycle += 1
    if cycle % 40 == 0
      crt << crt_row 
      crt_row = Array.new(40, '.')
      cycle = 0
    end
  end
  x += value.to_i if cmd == 'addx'
  sprite_position = [x - 1, x, x + 1]
end

puts "part2:"
crt.each { p _1.join }