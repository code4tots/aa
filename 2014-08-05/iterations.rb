# i = 251
# while i % 7 != 0 do
#   i += 1
# end
#
# p i

def factors(a_number)
  i = 1 
  while i <= a_number do
    if a_number % i == 0
      puts i
    end
    i += 1
  end
end

#p factors(100)

def bubble_sort(arr)
  arr_changed = true
  while arr_changed
    arr_changed = false
    (1...arr.size).each do |i|
      if arr[i - 1] > arr[i]
        arr[i - 1], arr[i] = arr[i], arr[i - 1]
        p arr
        arr_changed = true
      end
    end
  end
  arr
end

# x = ('a'..'z').to_a.shuffle
# p x
# bubble_sort(x)
# p x

def substrings(istr)
  substrs = []
  (0...istr.size).each do |start|
    ((start + 1)..istr.size).each do |finish|
      substr = istr[start...finish]
      substrs << substr unless substrs.include?(substr)
    end
  end
  substrs
end

# p substrings("cat")


def subwords(istr)
  str_arr = substrings(istr)
  
  dictionary_words = []
  # File.readlines("dictionary.txt") do |line|
  File.open("dictionary.txt").readlines.each do |line|
      dictionary_words << line.chomp
  end
  
  str_arr.select do |word|
    dictionary_words.include?(word)
  end
end

p subwords("cat")
