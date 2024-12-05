$match = "MAS"
$puzzle = STDIN.read.each_line.map { |line| line.strip.chars }.transpose
$max_x = $puzzle.length-1
$max_y = $puzzle[0].length-1

def test_diagonal (x,y)
  i = x
  j = y
  candidate = ""
  found = 0
  while i >= 0 && j >= 0 && i <= $max_x && j <= $max_y
    candidate += $puzzle[i][j]
    if candidate.end_with?($match) || candidate.end_with?($match.reverse)
      cross_text = $puzzle[i-2][j] + $puzzle[i-1][j-1] + $puzzle[i][j-2]
      if cross_text == $match || cross_text == $match.reverse
        found += 1
      end
    end
    i += 1
    j += 1
  end
  return found
end

northwest_edge_coords = (0..$max_x).to_a.product((0..$max_y).to_a).select { | x,y |
  x == 0 || y == 0
}

matches = northwest_edge_coords.reduce(0) { |count,coords| count + test_diagonal(coords[0],coords[1]) }
puts matches