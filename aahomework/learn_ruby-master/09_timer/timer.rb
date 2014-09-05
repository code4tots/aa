class Timer
  attr_accessor :seconds
  
  def time_string
    t = @seconds
    t, s = t.divmod 60
    t, m = t.divmod 60
    "%02d:%02d:%02d" % [t,m,s]
  end
  
  def initialize
    @seconds = 0
  end
end
