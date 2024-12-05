$match = "XMAS"
$puzzle = STDIN.read.each_line.map { |line| line.strip.chars }.transpose
$max_x = $puzzle.length-1
$max_y = $puzzle[0].length-1

def horizontal_string (x,y)
  if x == 0
    return $puzzle.transpose[y].join
  elsif x == $max_x
    return $puzzle.transpose[y].reverse.join
  else
    return nil
  end
end

def vertical_string (x,y)
  if y == 0
    return $puzzle[x].join
  elsif y == $max_y
    return $puzzle[x].reverse.join
  else
    return nil
  end
end

def diagonal_strings (x,y)
  directions = [[1,1], [-1,-1], [1,-1], [-1, 1]]
  return directions.map { | plus_x, plus_y | 
    i = x
    j = y
    candidate = ""
    while i >= 0 && j >= 0 && i <= $max_x && j <= $max_y
      candidate += $puzzle[i][j]
      i += plus_x
      j += plus_y
    end
    candidate
  }.select { |candidate| candidate.length >= $match.length }
end

edge_coords = (0..$max_x).to_a.product((0..$max_y).to_a).select { | x,y |
  x == 0 || x == $max_x || y == 0 || y == $max_y
}

candidates = []
edge_coords.each do | x,y |
  candidates << horizontal_string(x, y)
  candidates << vertical_string(x, y)
  candidates << diagonal_strings(x, y)
end
candidates = candidates.flatten.compact

matches = candidates.reduce(0) { |count,candidate| count + candidate.scan($match).length }
puts matches