require "test/unit"
require 'rainbow/refinement'
using Rainbow

SYMBOL_BLOCKED = "#"
SYMBOL_GUARD_POSITION = "^"

module Orientation
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3
end

module StepResult
  SUCCESS = 0
  VISITED_SAME_DIRECTION = 1
  STEPPED_OFF = 2
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
  attr_accessor :block_added
  attr_accessor :visited

  def initialize
    @blocked = false
    @block_added = false
    @visited = Array.new(4) { false }
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
        location.visited[self.orientation] = true
      end
    end
  end

  def get_location(position)
    if position.x < 0 || position.x >= self.grid.length || position.y < 0 || position.y >= self.grid[0].length
      return nil
    end
    return self.grid[position.x][position.y]
  end

  def next_position(position,orientation)
    move_x, move_y = [0,0]
    case orientation
    when Orientation::UP
      move_y = -1
    when Orientation::RIGHT
      move_x = 1
    when Orientation::DOWN
      move_y = 1
    when Orientation::LEFT
      move_x = -1
    end
    return Position.new(self.position.x + move_x,self.position.y + move_y)
  end

  def step
    self.position = next_position(self.position,self.orientation)
    new_location = get_location(self.position)
    if !new_location
      #stepped off
      return StepResult::STEPPED_OFF
    end

    loop do
      next_step = next_position(self.position,self.orientation)
      next_step_location = get_location(next_step)
      break unless next_step_location && (next_step_location.blocked || next_step_location.block_added)
      self.turn_right
    end

    visited_status = new_location.visited
    if visited_status[self.orientation]
      #puts "ALREADY VISITED [#{self.position.x},#{self.position.y}] for #{self.orientation} (#{visited_status})"
      return StepResult::VISITED_SAME_DIRECTION
    else
      visited_status[self.orientation] = true
      return StepResult::SUCCESS
    end
  end

  def turn_right
    @orientation += 1
    if @orientation > 3
      @orientation = Orientation::UP
    end
  end

  def visited_locations
    self.grid.flatten.sum { |location| location.visited.any? ? 1 : 0 }
  end

  def print
    self.grid.transpose.map.with_index { |row,y|
      row.map.with_index { |location,x|
        if x == self.position.x && y == self.position.y
          case self.orientation
          when Orientation::UP
            "^".cyan
          when Orientation::RIGHT
            ">".cyan
          when Orientation::LEFT
            "<".cyan
          when Orientation::DOWN
            "⌄".cyan
          end
        elsif location.blocked
          "#".red
        elsif location.block_added
          '0'
        elsif location.visited.any?
          visited_vertical = location.visited[Orientation::UP] || location.visited[Orientation::DOWN]
          visited_horizontal = location.visited[Orientation::LEFT] || location.visited[Orientation::RIGHT]
          if visited_vertical && visited_horizontal
            '+'
          elsif visited_vertical
            '|'
          else
            '-'
          end
        else
          ".".green
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
    puts "#{grid.print}\n\n"
    while grid.step != StepResult::STEPPED_OFF
      steps += 1
      # Uncommenting this unintentionally creates a sweet animation
      #puts "\033[2J"
      #puts grid.print
      #puts "\n"
    end
    puts grid.print
    return grid.visited_locations
  end

  def read_grid (input_lines)
    grid = Grid.new
    input_lines.each do |line|
      grid.add_row(line.strip)
    end
    return grid
  end

  def part_two (input)
    input_lines = input.readlines
    grid = read_grid(input_lines)
    start_position = grid.position

    # run through with original map
    while grid.step != StepResult::STEPPED_OFF
    end

    tested = 0
    potential_obstacles = []
    grid.grid.each.with_index do |column,x|
      column.each.with_index do |location,y|
        # skip start position, and unvisited positions
        if x == start_position.x && y == start_position.y || !location.visited.any?
          next
        end
        tested += 1
        copy = read_grid(input_lines)
        copy.grid[x][y].block_added = true
        #puts "#{copy.print}\n\n"

        loop do
          #puts "\033[2J"
          #puts copy.print
          #sleep 0.5
          result = copy.step
          if result == StepResult::STEPPED_OFF
            break
          elsif result == StepResult::VISITED_SAME_DIRECTION
            #puts "#{copy.print}\n\n"
            potential_obstacles << [x, y]
            break
          end
        end
      end
    end
    #puts "#{potential_obstacles.length} found in #{tested} tests"
    return potential_obstacles.length
  end
end

class Day6Test < Test::Unit::TestCase
  def test_part_one_example
    day6 = Day6.new
    result = day6.part_one(File.open("day6.example.txt"))
    puts "P1 EXAMPLE RESULT: #{result}"
    assert_equal(41, result)
  end

  def test_part_one
    day6 = Day6.new
    result = day6.part_one(File.open("day6.input.txt"))
    puts "P1 RESULT: #{result}"
    assert(result > 0)
  end

  def test_part_two_example
    day6 = Day6.new
    result = day6.part_two(File.open("day6.example.txt"))
    puts "P2 EXAMPLE RESULT: #{result}"
    assert_equal(6, result)
  end

  def test_part_two_test
    day6 = Day6.new
    result = day6.part_two(File.open("day6.test.txt"))
    puts "P2 TEST RESULT: #{result}"
    assert_equal(1, result)
  end

  def test_part_two
    day6 = Day6.new
    result = day6.part_two(File.open("day6.input.txt"))
    puts "P2 RESULT: #{result}"
    assert(result > 0)
  end
end