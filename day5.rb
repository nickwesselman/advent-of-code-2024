require "test/unit"
require "set"

class Day5

  def part_one (input)
    rules = Hash.new { |h, k| h[k] = Set.new }
    loop do
      rule = input.readline.strip
      break if rule.length == 0
      this_number,must_be_before = rule.split('|').map{ |s| s.to_i }
      rules[this_number] << must_be_before
    end

    middle_number_sum = 0
    input.each_line { |line| 
      update = line.split(',').map { |s| s.to_i }
      seen_numbers = Set.new
      correct_order = true
      update.each do |page|
        if seen_numbers.intersect?(rules[page])
          #puts "Out of order for #{page}: #{seen_numbers} #{rules[page]}"
          correct_order = false
          break
        end
        seen_numbers << page
      end
      if correct_order
        if update.length % 2 != 1
          raise "Update list has an even length, can't find the middle: #{update}"
        end
        middle_number_sum += update[update.length.div(2)]
      end
    }

    return middle_number_sum
  end

  def part_two (input)
    rules = Hash.new { |h, k| h[k] = Set.new }
    loop do
      rule = input.readline.strip
      break if rule.length == 0
      this_number,must_be_before = rule.split('|').map{ |s| s.to_i }
      rules[this_number] << must_be_before
    end

    middle_number_sum = 0
    input.each_line { |line| 
      update = line.split(',').map { |s| s.to_i }
      seen_numbers = []
      fixed_order = false
      update.each do |page|
        violations = Set.new(seen_numbers).intersection(rules[page])
        if !violations.empty?
          new_index = violations.map{ |i| seen_numbers.find_index(i) }.compact.min
          seen_numbers.insert(new_index, page)
          fixed_order = true
        else
          seen_numbers << page
        end
      end
      if fixed_order
        if seen_numbers.length % 2 != 1
          raise "Update list has an even length, can't find the middle: #{seen_numbers}"
        end
        middle_number_sum += seen_numbers[seen_numbers.length.div(2)]
      end
    }

    return middle_number_sum
  end

end

class Day5Test < Test::Unit::TestCase
  def test_part_one_example
    day5 = Day5.new
    result = day5.part_one(File.open("day5.example.txt"))
    assert(result == 143, "Incorrect result: #{result} != 143")
  end

  def test_part_one
    day5 = Day5.new
    result = day5.part_one(File.open("day5.input.txt"))
    puts "PART ONE ANSWER: #{result}"
    assert(result > 0)
  end

  def test_part_two_example
    day5 = Day5.new
    result = day5.part_two(File.open("day5.example.txt"))
    assert(result == 123, "Incorrect result: #{result} != 123")
  end

  def test_part_two
    day5 = Day5.new
    result = day5.part_two(File.open("day5.input.txt"))
    puts "PART TWO ANSWER: #{result}"
    assert(result > 0)
  end
end