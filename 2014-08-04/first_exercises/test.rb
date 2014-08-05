# def natural
#   k = (0...1000).map do |x|
#   x % 3 == 0 || x % 5 == 0 ? x : nil
#  end.compact.inject(:+)
#
# p k
# end
#
# natural

#
# def fibonacci
#   fibs = [1,2,3]
#   while fibs[-1] < 4_000_000
#     fibs << (fibs[-1] + fibs[-2])
#   end
#   fibs = fibs.select {|x| x.even? && x < 4_000_000 }
#   p fibs.inject(:+)
# end

# def largest_prime num
#   require 'prime'
#
#   i = 3
#
#   until Prime.prime?(num / i) && num % i == 0
#     i += 2
#     p i
#   end
#
#   num / i
#
#
# end
#
# p largest_prime  600_851_475_143

# def palindrome
#   longest = 0
#   (100..999).each do |x|
#     (100..999).each do |y|
#       a = x * y
#       longest = a if a.to_s == a.to_s.reverse && a > longest
#     end
#   end
#
#   p longest
# end
#
# palindrome

def divis
  i = 20
  13.times do
  p (2..20).select {|x| i % x == 0 }
  p i
  i += 2
  
  end
  
  p i
  
end

p divis






