def add x, y
  x + y
end

def subtract x, y
  x - y
end

def sum xs
  xs.inject (0) {|total,x| total + x }
end

def multiply *xs
  xs.inject (1) {|product,x| product * x }
end

def power a,b
  (1..b).inject(1){|result,_| result * a }
end

def factorial n
  (1..n).inject(1){|result,i| result * i }
end
