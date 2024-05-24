# frozen_string_literal: true

sections = []

File.readlines('lib/day_4/input.txt').each do |group|
  group.split(',').each do |pair|
    start, finish = pair.split('-')
    sections << (start.to_i..finish.to_i)
  end
end

number_of_intersections = 0
sections.each_slice(2) do |pair, pair2|
  pair.each do |num|
    if pair2.include?(num)
      number_of_intersections += 1
      break
    end
  end

  # number_of_intersections += 1 if pair.cover?(pair2) || pair2.cover?(pair) # part1
end

puts number_of_intersections # answer
