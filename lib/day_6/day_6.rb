# frozen_string_literal: true

message = File.read('lib/day_6/input.txt')

packet_markers = {}
message_markers = {}

idx = 0
message.each_char do
  next (idx += 1) if idx < 4

  packet_chars = message.chars[(idx - 4)..(idx - 1)]
  message_chars = message.chars[(idx - 14)..(idx - 1)]

  packet_markers[idx] = packet_chars unless packet_chars.tally.select { |_, n| n > 1 }.any?
  message_markers[idx] = message_chars unless (message_chars.empty? || message_chars.tally.select { |_, n| n > 1 }.any?)
  idx += 1
end

puts packet_markers
