class Dictionary
  def entries
    @entries
  end
  
  def keywords
    @entries.keys.sort
  end
  
  def initialize
    @entries = {}
  end
  
  def include? key
    @entries.include? key
  end
  
  def printable
    @entries.keys.sort.inject([]) {|m,key| m.push %Q{[#{key}] "#{@entries[key]}"} }.join("\n")
  end
  
  def find prefix
    @entries.each.inject({}) do |m,(key,value)|
      if key.start_with?(prefix)
        m[key] = value
      end
      m
    end
  end
  
  def add item
    if item.is_a? Hash
      item.each do |key, value|
        @entries[key] = value
      end
    else
      @entries[item] = nil
    end
  end
end