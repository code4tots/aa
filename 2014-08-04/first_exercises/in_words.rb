class Fixnum
  
  def in_words
    # special stuff that have to be listed, including digits
    h = {
      0 => 'zero',
      1 => 'one',
      2 => 'two',
      3 => 'three',
      4 => 'four',
      5 => 'five',
      6 => 'six',
      7 => 'seven',
      8 => 'eight',
      9 => 'nine',
      10 => 'ten',
      11 => 'eleven',
      12 => 'twelve',
      13 => 'thirteen',
      14 => 'fourteen',
      15 => 'fifteen',
      16 => 'sixteen',
      17 => 'seventeen',
      18 => 'eighteen',
      19 => 'nineteen',
      20 => 'twenty',
      30 => 'thirty',
      40 => 'forty',
      50 => 'fifty',
      60 => 'sixty',
      70 => 'seventy',
      80 => 'eighty',
      90 => 'ninety',
    }
    
    # orders of magnitudes at which we can reuse things
    scale = {
      100 => 'hundred',
      1000 => 'thousand',
      1000000 => 'million',
      1000000000 => 'billion',
      1000000000000 => 'trillion'
    }
    
    return h[self] if h.include?(self)
    
    if self < 100
      q, r = self.divmod 10
      return (q * 10).in_words + ' ' + r.in_words
    end
    
    scale.keys.sort.reverse.each do |k|
      if self >= k
        q, r = self.divmod k
        return q.in_words + ' ' + scale[k] + (r == 0 ? '' : (' ' + r.in_words))
      end
    end
  end
end
