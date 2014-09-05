def echo x
  x
end

def shout x
  x.upcase
end

def repeat x, n = 2
  ([x] * n).join(' ')
end

def start_of_word x, n
  x[0...n]
end

def first_word x
  x.split[0]
end

def titleize x
  # feels a little icky explicitly writing the little words here
  # in such an ad-hoc manner.
  x.split.collect.each_with_index { |word, i|
    (i==0 || !['the','and','over'].include?(word)) ?
      word.capitalize :
      word
  }.join(' ')
end
