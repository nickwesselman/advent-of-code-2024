require "test/unit"

class Equation
  attr_accessor :answer
  attr_accessor :numbers
end
  
class Day7

  def parse_equations(input)
    input.readlines.map { |line|
      answer_string,numbers_string = line.split(":")
      equation = Equation.new
      equation.answer = answer_string.to_i
      equation.numbers = numbers_string.strip.split(/\s/).map { |x| x.to_i }
      equation
    }
  end

  def part_one(input)
    total_calibration(input, false)
  end

  def part_two(input)
    total_calibration(input, true)
  end

  def total_calibration(input,with_concat)
    equations = parse_equations(input)
    equations.reduce(0) do |sum,equation|
      #puts "Testing #{equation.inspect}"
      numbers = equation.numbers
      operators = ["*","+"]
      operators << "||" if with_concat
      operator_permutations = operators.repeated_permutation(numbers.length-1).to_a
      #puts "Permutations: #{operator_permutations}"
      found = operator_permutations.any? do |operators|
        #puts "Testing #{numbers} with #{operators}"
        remaining = equation.answer
        operators.each.with_index do |operator,index|
          number = numbers[numbers.length-index-1]
          case operator
          when "*"
            break if remaining % number != 0
            remaining = remaining/number
          when "+"
            remaining = remaining - number
            break if remaining < 0
          when "||"
            # i || j = i * (10 ^ (number of digits in j)) + j
            remaining = remaining - number
            break if remaining < 0
            x = 10**(Math.log10(number).to_i+1)
            break if remaining % x != 0
            remaining = remaining/x
          end
        end
        remaining == numbers[0]
      end
      #puts "FOUND" if found
      found ? sum + equation.answer : sum
    end
  end

end


class Day7Test < Test::Unit::TestCase

  def test_part_one_example
    day7 = Day7.new
    result = day7.part_one(File.open("day7.example.txt"))
    puts "P1 EXAMPLE RESULT: #{result}"
    assert_equal(3769, result)
  end

  def test_part_one
    day7 = Day7.new
    result = day7.part_one(File.open("day7.input.txt"))
    puts "P1 RESULT: #{result}"
    assert(result > 0)
  end

  def test_part_two_example
    day7 = Day7.new
    result = day7.part_two(File.open("day7.example.txt"))
    puts "P2 EXAMPLE RESULT: #{result}"
    assert_equal(113407, result)
  end

  def test_part_two
    day7 = Day7.new
    result = day7.part_two(File.open("day7.input.txt"))
    puts "P2 RESULT: #{result}"
    assert(result > 0)
  end

end