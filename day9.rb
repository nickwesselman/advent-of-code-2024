require "test/unit"

class Disk
  attr_accessor :blocks

  def initialize(disk_map)
    @blocks = read_disk_map(disk_map)
  end

  def read_disk_map(map)
    blocks = Array.new
    map.chars.each.with_index do |node,i|
      num_blocks = node.to_i
      blocks.concat((1..num_blocks).to_a.map {
        i % 2 == 0 ? i/2 : nil
      })
    end
    return blocks
  end

  def checksum
    blocks.each.with_index.reduce(0) do |sum,(block,i)|
      block != nil ? sum += block * i : sum
    end
  end
end

class Defragger
  attr_accessor :current_free_index
  attr_accessor :current_file_index
  attr_accessor :disk

  def initialize(disk)
    @disk = disk
    @current_file_index = disk.blocks.length - 1
    @current_free_index = 0
    find_next_free
    find_next_file
  end

  def find_next_free
    while disk.blocks[self.current_free_index] != nil
      self.current_free_index += 1
    end
  end

  def find_next_file
    while disk.blocks[self.current_file_index] == nil
      self.current_file_index -= 1
    end
  end

  def defrag
    blocks = disk.blocks
    while current_file_index > current_free_index
      blocks[current_free_index] = blocks[current_file_index]
      blocks[current_file_index] = nil
      find_next_free
      find_next_file
    end
  end

end


def part_one(input)
  disk = Disk.new(input.read)
  defragger = Defragger.new(disk)
  defragger.defrag
  #puts "#{disk.blocks}"
  disk.checksum
end

class Day9Test < Test::Unit::TestCase

  def test_part_one_example
    result = part_one(File.open("day9.example.txt"))
    puts "P1 EXAMPLE RESULT: #{result}"
    assert_equal(1928, result)
  end

  def test_part_one
    result = part_one(File.open("day9.input.txt"))
    puts "P1 RESULT: #{result}"
    assert(result > 0)
  end

  # def test_part_two_example
  #   result = part_two(File.open("day9.example.txt"))
  #   puts "P2 EXAMPLE RESULT: #{result}"
  #   assert_equal(34, result)
  # end

  # def test_part_two
  #   result = part_two(File.open("day9.input.txt"))
  #   puts "P2 RESULT: #{result}"
  #   assert(result > 0)
  # end

end