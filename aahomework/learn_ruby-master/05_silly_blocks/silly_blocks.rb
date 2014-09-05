def reverser
  yield.split.map {|word| word.reverse }.join ' '
end

def adder i = 1
  yield + i
end

def repeater n = 1
  n.times { yield }
end
