# All of this ad-hoc specification makes me feel kinda dirty....

# 

def translate x
  def translate_word w
    capitalized = (w == w.capitalize)
    
    w.downcase!
    
    # move consonant sounds
    while !'aeiou'.include?(w[0])
      if w.start_with? 'qu'
        w = w[2..-1] + w[0..1]
      else
        w = w[1..-1] + w[0]
      end
    end
    
    w += 'ay'
    
    if capitalized
      w.capitalize!
    end
    
    w
  end
  
  x.split.map { |word| translate_word word }.join(' ')
end
