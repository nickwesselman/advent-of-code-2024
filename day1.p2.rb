list1 = []
list2 = Hash.new 0

file = File.open("day1.input.txt")
lines = file.read.split("\n")
lines.each do |line|
  split = line.split("\s")
  list1.push(split[0].to_i)
  list2_value = split[1].to_i
  list2[list2_value] = list2[list2_value] + 1
end

similarity_score = 0
list1.each do | item |
  similarity_score += item * list2[item]
  #puts "#{item} #{list2[item]} #{similarity_score}"
end

puts similarity_score