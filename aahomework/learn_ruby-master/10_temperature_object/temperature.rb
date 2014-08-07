class Temperature
  
  def in_fahrenheit
    self.class.ctof @celsius
  end
  
  def in_celsius
    @celsius
  end
  
  def initialize options = {}
    # comments request that `:celcius` (sic) and `:fahrenheit` be used as keys in the option,
    # but the code itself uses `:c` and `:f` instead.
    
    if options.include? :f
      options[:fahrenheit] = options[:f]
    elsif options.include? :c
      options[:celsius] = options[:c]
    end
    
    if options.include? :celsius
      @celsius = options[:celsius].to_f
    else
      @celsius = self.class.ftoc options[:fahrenheit]
    end
  end
  
  def self.from_celsius c
    self.new :c => c
  end
  
  def self.from_fahrenheit f
    self.new :f => f
  end
  
  def self.ftoc f
    (f.to_f - 32) * 5 / 9
  end
  
  def self.ctof c
    c.to_f * 9 / 5 + 32
  end
  
end

class Celsius < Temperature
  def initialize c
    super :c => c
  end
end

class Fahrenheit < Temperature
  def initialize f
    super :f => f
  end
end