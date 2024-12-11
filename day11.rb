require "test/unit"

class List
  attr_accessor :start_node
  attr_accessor :end_node

  def push(node)
    if self.start_node == nil && self.end_node == nil
      self.start_node = self.end_node = node
    else
      self.end_node.next = node
      self.end_node = node
    end
  end
end

class ListNode
  attr_accessor :value
  attr_accessor :next

  def initialize(value)
    @value = value
  end
end

def part_one(input)
  list = List.new
  input.read.split(" ").each do |rock|
    list.push(ListNode.new(rock.to_i))
  end

  25.times do |i|
    puts "***ITERATION #{i}***\n"
    current = list.start_node
    while current != nil
      puts current.value
      if current.value == 0
        current.value = 1
        current = current.next
        next
      end

      value_s = current.value.to_s
      if value_s.length % 2 == 0
        value1,value2 = value_s.chars.each_slice(value_s.length / 2).map(&:join)
        existing_next = current.next
        current.value = value1.to_i
        new_node = ListNode.new(value2.to_i)
        current.next = new_node
        new_node.next = existing_next
        current = new_node
      else
        current.value = current.value * 2024
      end
      current = current.next
    end
    puts "\n"
  end

  #count em
  num_stones = 0
  current = list.start_node
  while current != nil
    num_stones += 1
    current = current.next
  end
  return num_stones
end

class Day11Test < Test::Unit::TestCase

  def test_part_one_example
    result = part_one(File.open("day11.example.txt"))
    puts "P1 EXAMPLE RESULT: #{result}"
    assert_equal(55312, result)
  end

  def test_part_one
    result = part_one(File.open("day11.input.txt"))
    puts "P1 RESULT: #{result}"
    assert(result > 0)
  end

  # def test_part_two_example
  #   result = part_two(File.open("day11.example.txt"))
  #   puts "P2 EXAMPLE RESULT: #{result}"
  #   assert_equal(81, result)
  # end

  # def test_part_two
  #   result = part_two(File.open("day11.input.txt"))
  #   puts "P2 RESULT: #{result}"
  #   assert(result > 0)
  # end

end