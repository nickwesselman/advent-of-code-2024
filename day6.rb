require "test/unit"

SYMBOL_BLOCKED = "#"
SYMBOL_GUARD_POSITION = "^"

module Orientation
  UP = 1
  RIGHT = 2
  DOWN = 3
  LEFT = 4
end

class Position
  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class GridLocation
  attr_accessor :blocked
  attr_accessor :visited

  def initialize
    @blocked = false
    @visited = false
  end
end

class Grid
  attr_accessor :grid
  attr_accessor :position
  attr_accessor :orientation

  def initialize
    @grid = Array.new(0)
    @position = Position.new(0,0)
    @orientation = Orientation::UP
  end

  def add_row(row_string)
    if self.grid.length == 0
      self.grid = Array.new(row_string.length) { Array.new(0) }
    end
    row_string.strip.chars.each.with_index do |position_char,index|
      location = GridLocation.new
      self.grid[index] << location
      case position_char
      when SYMBOL_BLOCKED
        location.blocked = true
      when SYMBOL_GUARD_POSITION
        self.position = Position.new(index, self.grid[index].length-1)
        location.visited = true
      end
    end
  end

  def step
    move_x, move_y = [0,0]
    case @orientation
    when Orientation::UP
      move_y = -1
    when Orientation::RIGHT
      move_x = 1
    when Orientation::DOWN
      move_y = 1
    when Orientation::LEFT
      move_x = -1
    end
    self.position = Position.new(self.position.x + move_x,self.position.y + move_y)
    if self.grid[self.position.x].nil? || self.grid[self.position.x][self.position.y].nil?
      #stepped off
      return false
    end
    self.grid[self.position.x][self.position.y].visited = true
    next_step = Position.new(self.position.x + move_x,self.position.y + move_y)
    if !self.grid[next_step.x].nil? && !self.grid[next_step.x][next_step.y].nil? && self.grid[next_step.x][next_step.y].blocked
      self.turn_right
    end
    return true
  end

  def turn_right
    @orientation += 1
    if @orientation > 4
      @orientation = Orientation::UP
    end
  end

  def visited_locations
    self.grid.flatten.sum { |location| location.visited ? 1 : 0 }
  end

  def print
    self.grid.transpose.map.with_index { |row,y|
      row.map.with_index { |location,x|
        if x == self.position.x && y == self.position.y
          case self.orientation
          when Orientation::UP
            '^'
          when Orientation::RIGHT
            '>'
          when Orientation::LEFT
            '<'
          when Orientation::DOWN
            '⌄'
          end
        elsif location.blocked
          '#'
        elsif location.visited
          'X'
        else
          '.'
        end
      }.join
    }.join("\n")
  end
end

class Day6
  def part_one (input)
    grid = Grid.new
    input.each_line do |line|
      grid.add_row(line.strip)
    end
    steps = 0
    puts grid.print
    puts "\n"
    while grid.step
      steps += 1
      #puts "Step #{steps}"
      #puts grid.print
      #puts "\n"
    end
    puts grid.print
    return grid.visited_locations
  end
end

class Day6Test < Test::Unit::TestCase
  def test_part_one_example
    day6 = Day6.new
    result = day6.part_one(File.open("day6.example.txt"))
    puts "EXAMPLE RESULT: #{result}"
    assert_equal(41, result)
  end

  def test_part_one
    day6 = Day6.new
    result = day6.part_one(File.open("day6.input.txt"))
    puts "RESULT: #{result}"
    puts assert(result > 0)
  end
end