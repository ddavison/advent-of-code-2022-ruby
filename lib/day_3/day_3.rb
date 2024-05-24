# frozen_string_literal: true

# https://adventofcode.com/2022/day/3
rucksacks = []

class Rucksack
  attr_accessor :items, :compartments

  # New Rucksack
  # @param [String] items
  def initialize(items)
    @items = items

    @compartments = [
      Compartment.new(items[0..(items.size / 2 - 1)]),
      Compartment.new(items[(items.size / 2)..])
    ]
  end

  def to_s
    @items
  end

  def shared_items
    first, second = compartments.map do |compartment|
      compartment.compartment.chars.uniq
    end

    first & second
  end

  def shared_values
    shared_items.map do |i|
      Item.new(i).value.to_i
    end.reduce(&:+)
  end

  Compartment = Struct.new(:compartment) do
    def items
      compartment.chars.each_with_object([]) do |c, i|
        i << Item.new(c)
      end
    end
  end

  Item = Struct.new(:item) do
    def value
      map = {}
      (97..122).each { |n| map[n.chr] = (1..26).map(&:to_s)[n - 97] }
      (65..90).each { |n| map[n.chr] = (27..52).map(&:to_s)[n - 65] }
      map[item]
    end
  end
end

File.readlines('lib/day_3/input.txt').each do |line|
  rucksacks << Rucksack.new(line.chomp)
end

# Part One
puts rucksacks.map(&:shared_values).reduce(&:+)

# Part Two
groups = []
class Group
  attr_accessor :rucksacks

  # @param [Array<Rucksack>] group
  def initialize(group)
    @rucksacks = group
  end

  def badge
    first, second, third = rucksacks.map(&:to_s).map(&:chars)
    (first & second & third).first
  end
end

rucksacks.each_slice(3) { |g| groups << Group.new(g) }

puts groups.map(&:badge).map { |g| Rucksack::Item.new(g).value.to_i }.reduce(&:+)
