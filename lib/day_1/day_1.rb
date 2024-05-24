# frozen_string_literal: true

elves = []
elves_map = {}

input = File.read('lib/day_1/input.txt')

input.split("\n\n").each do |calories|
  elves << calories.split("\n").map(&:to_i).reduce(&:+)
end

elves.each_with_index do |elf, i|
  elves_map["elf_#{i + 1}"] = elf
end

ascending = elves_map.sort_by { |_, b| b }

# Part One
p ascending.last[1] # answer

# Part Two
sum = 0
ascending.last(3).each { |_, b| sum += b }
p sum # answer
