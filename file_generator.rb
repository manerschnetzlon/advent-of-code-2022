(1..25).each do |day|
  Dir.mkdir("inputs") unless Dir.exist?("inputs")
  name = "day#{format('%02d', day)}"
  unless File.exist?("#{name}.rb")
    File.open("#{name}.rb", 'w') do |f|
      f.write("file = File.open('inputs/input_#{name}.txt')\nfile_array = file.read.split(\"\\n\")")
    end
  end

  File.open("inputs/input_#{name}.txt", 'w') unless File.exist?("inputs/input_#{name}.txt")
end