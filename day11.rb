# frozen_string_literal: true

file = File.open('inputs/input_day11.txt')
file_array = file.read.split("\n\n")

class Monkey
  attr_reader :number, :operation, :tester, :monkey_success, :monkey_failure
  attr_accessor :items, :inspections

  def initialize(monkey_data)
    @number = monkey_data[:number]
    @items = monkey_data[:items]
    @operation = monkey_data[:operation]
    @tester = monkey_data[:tester]
    @monkey_success = monkey_data[:monkey_success]
    @monkey_failure = monkey_data[:monkey_failure]
    @inspections = 0
    @keep_away = monkey_data[:keep_away]
  end

  def self.find(monkey_number, keep_away)
    keep_away.monkeys.select { |monkey| monkey.number == monkey_number }.first
  end
end

class KeepAway
  attr_reader :monkeys

  def initialize(input)
    @input = input
    @monkeys = []
    @current_monkey = []
    @relief = 1
  end

  def game(rounds)
    setup
    rounds.times do
      @monkeys.each { |monkey| turn(monkey) }
    end
    display_result
  end

  def display_result
    p @monkeys.map(&:inspections).max(2).reduce(&:*)
  end

  private

  def setup
    @input.each do |input_turn|
      monkey = input_turn.split("\n")
      monkey_data = parse(monkey)
      monkey = Monkey.new(monkey_data)
      @monkeys << monkey
    end
    @relief = @monkeys.map(&:tester).inject(:*)
  end

  def parse(monkey)
    {
      number: monkey[0].scan(/\d+/).first.to_i,
      items: monkey[1].scan(/\d+/).map(&:to_i),
      operation: monkey[2].scan(/old .+/).first,
      tester: monkey[3].scan(/\d+/).first.to_i,
      monkey_success: monkey[4].scan(/\d+/).first.to_i,
      monkey_failure: monkey[5].scan(/\d+/).first.to_i,
      keep_away: self
    }
  end

  def turn(current_monkey)
    current_monkey.items.each do |item|
      current_monkey.inspections += 1
      item = operation(item, current_monkey)
      # item /= 3
      item %= @relief
      next_monkey_num = find_next_monkey(item, current_monkey)
      Monkey.find(next_monkey_num, self).items << item
    end
    current_monkey.items = []
  end

  def operation(item, monkey)
    eval monkey.operation.gsub('old', item.to_s)
  end

  def find_next_monkey(item, monkey)
    (item % monkey.tester).zero? ? monkey.monkey_success : monkey.monkey_failure
  end
end

keep_away = KeepAway.new(file_array)
keep_away.game(10_000)
