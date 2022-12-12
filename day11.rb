# frozen_string_literal: true

file = File.open('inputs/input_day11.txt')
file_array = file.read.split("\n\n")

class Monkey
  attr_reader :number
  attr_accessor :items, :inspections

  def initialize(number, keep_away)
    @number = number
    @items = []
    @inspections = 0
    @keep_away = keep_away
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
  end

  def game(rounds)
    setup
    rounds.times do
      @input.each do |input|
        turn(input)
      end
    end
    display_result
  end

  def display_result
    p @monkeys.map(&:inspections).max(2).reduce(&:*)
  end

  private

  def setup
    @input.each do |input_turn|
      bloc = input_turn.split("\n").map { _1.scan(/\d+/) }
      items = bloc[1].map(&:to_i)
      monkey = Monkey.new(bloc[0].first.to_i, self)
      monkey.items = items
      @monkeys << monkey
    end
  end

  def turn(input_turn)
    elements = parse(input_turn)
    @current_monkey = Monkey.find(elements[:num], self)
    @current_monkey.items.each do |item|
      @current_monkey.inspections += 1
      multiplier = elements[:multi].empty? ? item : elements[:multi].first.to_i
      item = elements[:operator] == '+' ? (item + multiplier) / 3 : (item * multiplier) / 3
      next_monkey_num = (item % elements[:tester]).zero? ? elements[:monkey_true] : elements[:monkey_false]
      Monkey.find(next_monkey_num, self).items << item
    end
    @current_monkey.items = []
  end

  def parse(input)
    bloc = input.split("\n")
    {
      num: bloc[0].scan(/\d+/).first.to_i,
      operator: bloc[2].scan(/(\+|\*)/).flatten.first,
      multi: bloc[2].scan(/\d+/),
      tester: bloc[3].scan(/\d+/).first.to_i,
      monkey_true: bloc[4].scan(/\d+/).first.to_i,
      monkey_false: bloc[5].scan(/\d+/).first.to_i
    }
  end
end

keep_away = KeepAway.new(file_array)
keep_away.game(20)
