# frozen_string_literal: true

# Crane Operation Software
class ElvenLogistics
  attr_reader :stacks

  # New logistics
  # @param [String] file the path to the file to parse
  def initialize(file)
    @stacks = []
    crates = []

    File.readlines(file).each do |line|
      # add existing crates from top to bottom to buffer, then add later
      case line
      when /^move/
        line.scan(/move (\d+) from (\d+) to (\d+)/) do |amount, from, to|
          stacks[from.to_i - 1].move_to(stacks[to.to_i - 1], amount.to_i)
        end
      when /^ \d/
        # stacks line
        line.split.each do |stack_no|
          stacks << Stack.new(stack_no)
        end

        crates.each do |row|
          i = 0
          row.chars.each_slice(4) do |_, crate_name|
            stacks[i] << Crate.new(crate_name) unless crate_name == ' '
            i += 1
          end
        end

        stacks.each { |stack| stack.inventory.reverse! }
      else
        # add crate to buffer, then add to Stacks
        crates << line
      end
    end
  end

  Crate = Struct.new(:name) do
    def to_s
      "[#{name}]"
    end
  end

  # Stack of Crates
  class Stack
    attr_reader :number

    def initialize(number)
      @number = number
      @inventory = []
    end

    def inventory
      @inventory.compact!
      @inventory
    end

    # Add a crate to this stack
    # @param [Crate] crate the crate to add
    def <<(crate)
      @inventory << crate
    end

    # Move the top-most crate to another stack
    # @param [Stack] other_stack the other stack to move the crate to
    # @param [Integer] amount the number of crates to move
    def move_to(other_stack, amount = 1)
      amount.times { other_stack << @inventory.pop }
    end
  end

  # Part 2 Stack
  class Stack9001 < Stack
    def move_to(other_stack, amount = 1)
      other_stack.inventory.concat(@inventory.pop(amount))
    end
  end
end

co = ElvenLogistics.new('lib/day_5/input.txt')

puts co.stacks.map { |s| s.inventory.last.name }.join # answer
