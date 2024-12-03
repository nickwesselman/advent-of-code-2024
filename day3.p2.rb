pos_memory = File.open("day3.input.txt").read
mul_regex = /(do\(\))|(don't\(\))|(mul\(([0-9]{1,3}),([0-9]{1,3})\))/

total = 0
enabled = true
matches = pos_memory.to_enum(:scan,mul_regex).map {
  if $1
    enabled = true
    next
  elsif $2
    enabled = false
    next
  elsif $3 && enabled
    total += $4.to_i * $5.to_i
  end
}

puts total