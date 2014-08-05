def digit_to_str digit
  if digit < 10
    ('0'.ord + digit).chr
  else
    ('A'.ord + digit - 10).chr
  end
end

def num_to_s num, base
  # nums = {
  #   0 => 'zero',
  #   1
  # }
  result = ''
  while num > 0
    result += digit_to_str(num % base)
    num = num / base
  end
  result.reverse
end

#p (digit_to_str 6)
p num_to_s 234, 2
