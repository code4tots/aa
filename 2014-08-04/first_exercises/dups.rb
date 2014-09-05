class Array
    def my_uniq 
      require 'set'
  
      self.to_set.to_a
  
    end
end

p [1,1,4,4,54,5].my_uniq
