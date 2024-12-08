require "test/unit"

def in_range(antinode)
  return antinode[0] >= 0 && antinode[0] <= $max_x && antinode[1] >= 0 && antinode[1] <= $max_y
end

def find_antinodes(input,with_harmonics)
  antennas = Hash.new { |h,k| h[k] = Array.new(0) }
  antinodes = Set.new

  lines = input.read.lines
  $max_y = lines.length - 1
  $max_x = lines[0].strip.length - 1
  lines.each.with_index do |line,y|
    line.strip.chars.each.with_index do |node,x|
      if node == "."
        next
      end
      matching_antennas = antennas[node]
      matching_antennas.each do |antenna|
        distance = [antenna[0] - x, antenna[1] - y]
        if with_harmonics
          current = [x,y]
          while in_range(current) do
            antinodes << current
            current = [current[0] - distance[0],current[1] - distance[1]]
          end
          current = antenna
          while in_range(current) do
            antinodes << current
            current = [current[0] + distance[0],current[1] + distance[1]]
          end
        else
          candidates = [[x - distance[0], y - distance[1]],[antenna[0] + distance[0], antenna[1] + distance[1]]]
          candidates.each do |antinode|
            if in_range(antinode)
              antinodes << antinode
            end
          end
        end
      end
      matching_antennas << [x,y]
    end
  end
  return antinodes.length
end

def part_one(input)
  find_antinodes(input,false)
end

def part_two(input)
  find_antinodes(input,true)
end

class Day8Test < Test::Unit::TestCase

  def test_part_one_example
    result = part_one(File.open("day8.example.txt"))
    puts "P1 EXAMPLE RESULT: #{result}"
    assert_equal(14, result)
  end

  def test_part_one
    result = part_one(File.open("day8.input.txt"))
    puts "P1 RESULT: #{result}"
    assert(result > 0)
  end

  def test_part_two_example
    result = part_two(File.open("day8.example.txt"))
    puts "P2 EXAMPLE RESULT: #{result}"
    assert_equal(34, result)
  end

  def test_part_two
    result = part_two(File.open("day8.input.txt"))
    puts "P2 RESULT: #{result}"
    assert(result > 0)
  end

end