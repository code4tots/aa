# def caesar string, num
#   string.split(//).map! do |x|
#     ('a'.ord + (x.ord - 'a'.ord + num + 26) % 26).chr
#   end.join
# end
   

def alternate string, num
  range = ('a'..'z').to_a.rotate(num)
  working = string.split(//)
  working.map! do |x|
    x = range[('a'..'z').to_a.index(x)]
  end.join
  
  

end


p alternate("hello",3)
