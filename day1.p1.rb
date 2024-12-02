list1 = []
list2 = []

file = File.open("day1.input.txt")
lines = file.read.split("\n")
lines.each do |line|
  split = line.split("\s")
  list1.push(split[0].to_i)
  list2.push(split[1].to_i)
end

list1 = list1.sort
list2 = list2.sort

total_distance = 0
list1.each.with_index(0) do |item, index|
  distance = (item - list2[index]).abs
  total_distance += distance
  puts "#{item} #{list2[index]} #{distance} #{total_distance}"
end

puts total_distance