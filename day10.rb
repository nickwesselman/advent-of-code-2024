require "test/unit"
require "set"


def try_path(map, x, y, current_height, found_nines)
  if x < 0 || y < 0 || x >= map[0].length || y >= map.length
    return 0
  elsif map[y][x] != current_height + 1
    return 0
  elsif map[y][x] == 9
    found_nines << [x,y]
    return 1
  else
    return [[x-1,y],[x,y-1],[x+1,y],[x,y+1]].reduce(0) { |sum,node| sum + try_path(map, node[0], node[1], current_height+1, found_nines)}
  end
end

def part_one(input)
  map = Array.new
  input.readlines.each do |line|
    map << line.strip.chars.map { |x| x.to_i }.to_a
  end

  return map.each.with_index.reduce(0) do |sum_y,(rows,y)|
    row_total = rows.each.with_index.reduce(0) do |sum_x,(node,x)|
      if node != 0
        sum_x
      end
      found_nines = Set.new
      try_path(map, x, y, -1, found_nines)
      sum_x + found_nines.length
    end
    sum_y + row_total
  end
end

def part_two(input)
  map = Array.new
  input.readlines.each do |line|
    map << line.strip.chars.map { |x| x.to_i }.to_a
  end

  _unused = Set.new
  return map.each.with_index.reduce(0) do |sum_y,(rows,y)|
    row_total = rows.each.with_index.reduce(0) do |sum_x,(node,x)|
      sum_x + (node == 0 ? try_path(map, x, y, -1, _unused) : 0)
    end
    sum_y + row_total
  end
end

class Day10Test < Test::Unit::TestCase

  def test_part_one_example
    result = part_one(File.open("day10.example.txt"))
    puts "P1 EXAMPLE RESULT: #{result}"
    assert_equal(36, result)
  end

  def test_part_one
    result = part_one(File.open("day10.input.txt"))
    puts "P1 RESULT: #{result}"
    assert(result > 0)
  end

  def test_part_two_example
    result = part_two(File.open("day10.example.txt"))
    puts "P2 EXAMPLE RESULT: #{result}"
    assert_equal(81, result)
  end

  def test_part_two
    result = part_two(File.open("day10.input.txt"))
    puts "P2 RESULT: #{result}"
    assert(result > 0)
  end

end