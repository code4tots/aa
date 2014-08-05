def my_transpose m
  r = m.size
  c = m[0].size
  (0...c).map{ |i| (0...r).map{|j| m[j][i]} }
end

rows = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
]

p my_transpose(rows)
