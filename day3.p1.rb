pos_memory = File.open("day3.input.txt").read
mul_regex = /mul\(([0-9]{1,3}),([0-9]{1,3})\)/

total = 0

# Really, Ruby?
matches = pos_memory.to_enum(:scan,mul_regex).map {
  total += $1.to_i * $2.to_i
}

puts total