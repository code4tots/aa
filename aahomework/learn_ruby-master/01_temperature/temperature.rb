def ftoc f
  # fahrenheit to celsius
  (f.to_f - 32) * 5/9
end

def ctof c
  # celsius to fahrenheit
  c.to_f * 9/5 + 32
end