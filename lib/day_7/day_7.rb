# frozen_string_literal: true

# Command
class Command
  class << self
    # list current directory
    def ls
      chdir = yield
      chdir.ls
    end

    # cd into a directory
    def cd(dir)
      chdir = yield
      return chdir if chdir.name == dir # change into the same dir
      return chdir.parent if dir == '..' # cd ..

      chdir.cd(dir)
    end
  end

  def initialize(command, arg = nil)
    @command = command
    @arg = arg
  end

  def execute(&block)
    raise NotImplementedError
  end
end

# File
class AFile
  attr_reader :name, :size, :parent

  # @param [String] name of the file
  # @param [String,Integer] size of the file
  # @param [Directory] parent directory of the file
  def initialize(name, size, parent)
    @name = name
    @size = size.to_i
    @parent = parent
  end

  def to_s
    "#{size} #{name}"
  end
end

# Directory
class Directory < AFile
  attr_reader :name, :files, :parent

  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @files = []
  end

  # @return [Integer] the size of the directory (aggregate file sizes)
  def size
    return 0 if @files.empty?

    @files.map(&:size).reduce(&:+)
  end

  # Make directory under directory
  # @param [String] name of the directory
  def mkdir(name)
    new_dir = Directory.new(name, self)
    @files << new_dir
    new_dir
  end

  def touch(name, size)
    new_file = AFile.new(name, size, self)
    @files << new_file
    new_file
  end

  def path
    parent = @name

    until parent.nil?
      
    end
  end

  # check if a file or dir exists
  # @param [String] name of the file or dir to check for
  def exist?(name)
    @files.select { |f| f.name == name }.any?
  end

  # list directory contents
  def ls
    # sort by dir
    puts "dir #{name}"

    files.each do |file|
      puts "  #{file.size} #{file.name}"
    end
  end

  def cd(dir)
    return mkdir(dir) unless exist?(dir)

    files.find { |f| f.name == dir }
  end

  def to_s
    "dir #{name}"
  end
end

ROOT = Directory.new('/')
chdir = ROOT
output_buffer = []

File.open('lib/day_7/input.txt') do |file|
  while (line = file.readline.chomp)
    break if file.eof?

    case line
    when /^\$/ # start of command
      command, arg = line.split(' ', 4)[1..2]
      puts "#{$.}: $ #{command} #{arg}"

      case command
      when 'cd'
        chdir = Command.cd(arg) { chdir }
      when 'ls'
        Command.ls { chdir }
      end
    when /^dir/ # directory
      _, name = line.split(' ')
      chdir.mkdir(name)
    when /^\d+/ # file
      size, name = line.split(' ')
      chdir.touch(name, size)
    else
      # puts line
    end
  end
end

puts chdir
