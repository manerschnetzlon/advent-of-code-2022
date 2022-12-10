file = File.open('inputs/input_day07.txt')
file_array = file.read.split("\n")

class ShellDirectory
  attr_accessor :parent, :subdirectories, :files

  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @subdirectories = {}
    @files = {}
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end

  def total_size
    files_size = @files.values.map { |file| file.file_size }.sum
    subdirectories_size = @subdirectories.values.map { |dir| dir.total_size }.sum
    files_size + subdirectories_size
  end
end

class ShellFile
  attr_accessor :name, :file_size, :parent

  def initialize(name, file_size, parent)
    @name = name
    @file_size = file_size
    @parent = parent
  end
end

class Shell
  def initialize(current, input)
    @current = current
    @input = input
  end

  def navigate
    @input.each do |line|
      if line.start_with?("$")
        a, b, c = line.split
        if b == "cd"
          if c == ".."
            @current = @current.parent
          else
            @current.subdirectories[c] ||= ShellDirectory.new(c, @current)
            @current = @current.subdirectories[c]
          end
        end
      else
        a, b = line.split
        if a == "dir"
          @current.subdirectories[b] ||= ShellDirectory.new(b, @current) 
        else
          @current.files[b] = ShellFile.new(b, a.to_i, @current)
        end
      end
    end
  end

  def find_directories_less_than(size)
    ShellDirectory.all.select do |dir| 
      dir.total_size < size
    end
  end

  def find_directories_more_than(size)
    ShellDirectory.all.select do |dir| 
      dir.total_size >= size
    end
  end
end

current = ShellDirectory.new('/')
shell = Shell.new(current, file_array)
shell.navigate
p "part1: #{shell.find_directories_less_than(100000).map(&:total_size).sum}"

free_space = 70000000 - current.total_size
needed_space = 30000000 - free_space
p "part2: #{shell.find_directories_more_than(needed_space).sort_by!(&:total_size).first.total_size}"
