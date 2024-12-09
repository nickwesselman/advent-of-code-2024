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

  def print
    blocks.map { |x| x != nil ? x : "." }.join
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

  def find_free_block(size,max_location)
    blocks = self.disk.blocks
    i = 0
    found_free = 0
    while i < max_location
      if blocks[i] == nil
        found_free += 1
      else
        found_free = 0
      end
      if found_free == size
        return i - size + 1
      end
      i += 1
    end
    return nil
  end

  def find_next_file_contiguous(next_id = nil)
    blocks = self.disk.blocks

    # move to next non-empty
    find_next_file

    # move to next id if provided
    if next_id != nil
      while blocks[self.current_file_index] != next_id
        self.current_file_index -= 1
        if self.current_file_index < 0
          raise "Couldn't find #{next_id}"
        end
      end
    end

    starting_location = self.current_file_index
    current_id = blocks[starting_location]
    current_length = 0
    while self.current_file_index > 0 && blocks[self.current_file_index] == current_id
      current_length += 1
      self.current_file_index -= 1
    end
    return [current_id,self.current_file_index+1,current_length]
  end

  def defrag(contiguous)
    blocks = self.disk.blocks
    if !contiguous
      while current_file_index > current_free_index
        blocks[current_free_index] = blocks[current_file_index]
        blocks[current_file_index] = nil
        find_next_free
        find_next_file
      end
    else
      # don't use current free index
      id,location,length = find_next_file_contiguous
      loop do
        #puts "Defragging #{id} at #{location} size #{length}"
        #puts "#{disk.print}"
        free_block = find_free_block(length,location)
        if free_block != nil
          #puts "Found free block at #{free_block}"
          (free_block...free_block+length).to_a.each { |i| blocks[i] = id }
          (location...location+length).to_a.each { |i| blocks[i] = nil }
        end
        break if id == 0
        id,location,length = find_next_file_contiguous(id - 1)
      end
    end
  end
end


def part_one(input)
  disk = Disk.new(input.read)
  defragger = Defragger.new(disk)
  defragger.defrag(false)
  #puts "#{disk.blocks}"
  disk.checksum
end

def part_two(input)
  disk = Disk.new(input.read)
  defragger = Defragger.new(disk)
  defragger.defrag(true)
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

  def test_part_two_example
    result = part_two(File.open("day9.example.txt"))
    puts "P2 EXAMPLE RESULT: #{result}"
    assert_equal(2858, result)
  end

  def test_part_two
    result = part_two(File.open("day9.input.txt"))
    puts "P2 RESULT: #{result}"
    assert(result > 0)
  end

end