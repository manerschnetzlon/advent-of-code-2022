file = File.open('inputs/input_day08.txt')
file_array = file.read.split("\n")

class Forest
  attr_accessor :trees

  def initialize
    @trees = []
  end

  def visible_trees
    @trees.select { |tree| tree.visible }
  end

  def check_neighbours(tree, neighbours)
    return if tree.visible

    tree.visible = neighbours.all? { |t| t.height < tree.height }
  end

  def scan_part1
    @trees.each do |tree|
      check_neighbours(tree, tree.right_trees)
      check_neighbours(tree, tree.left_trees)
      check_neighbours(tree, tree.up_trees)
      check_neighbours(tree, tree.down_trees)
    end
  end

  def check_line_view(tree, neighbours)
    return 0 if neighbours.empty?

    neighbours.each_with_index do |t, index|
      return index + 1 if t.height >= tree.height
    end
    return neighbours.count
  end

  def scenic_score(tree)
    up = check_line_view(tree, tree.up_trees.reverse)
    left = check_line_view(tree, tree.left_trees.reverse)
    right = check_line_view(tree, tree.right_trees)
    down = check_line_view(tree, tree.down_trees)
    up * left * right * down
  end

  def scan_part2
    @trees.map do |tree|
      scenic_score(tree)
    end
  end
end

class Tree
  attr_reader :x, :y, :height
  attr_accessor :visible

  def initialize(x, y, height, forest)
    @x = x
    @y = y
    @height = height
    @visible = false
    @forest = forest
  end

  def self.find(x_to_find, y_to_find)
    @forest.trees.select { |tree| tree.x == x_to_find || tree.y == y_to_find }.first
  end

  def right_trees
    @forest.trees.select { |tree| tree.y == y && tree.x > x}
  end

  def left_trees
    @forest.trees.select { |tree| tree.y == y && tree.x < x}
  end

  def up_trees
    @forest.trees.select { |tree| tree.y < y && tree.x == x}
  end

  def down_trees
    @forest.trees.select { |tree| tree.y > y && tree.x == x}
  end
end

forest = Forest.new
file_array.each_with_index do |line, y|
  line.chars.each_with_index do |tree, x|
    tree = Tree.new(x, y, tree, forest)
    forest.trees << tree
  end
end

forest.scan_part1
p "part1: #{forest.visible_trees.count}"

tree = forest.trees.first
p "part2: #{forest.scan_part2.max}"
