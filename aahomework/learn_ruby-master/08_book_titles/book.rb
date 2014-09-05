class Book
  attr_accessor :title
  
  def title= t
    t = t.capitalize.split.map do |word|
      if ['a','an','the','and','in','of'].include? word
        word
      else
        word.capitalize
      end
    end
    @title = t.join ' '
  end
end
