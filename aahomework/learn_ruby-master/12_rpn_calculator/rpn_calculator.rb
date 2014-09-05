# Keepin' it DRY

class RPNCalculator
  @@operators = {
    :plus => :+,
    :minus => :-,
    :times => :*,
    :divide => :/
  }
  
  @@operators.each do |method_name,operation|
    define_method method_name do
      if @stack.empty?
        raise "calculator is empty"
      end
      do_operation operation
    end
  end
  
  def do_operation operation
    @stack[-2] = @stack[-2].send(operation,@stack[-1])
    @stack.pop
  end
  
  def initialize
    @stack = []
  end
  
  def value
    @stack[-1]
  end
  
  def push x
    @stack.push x.to_f
  end
  
  def tokens ts
    ops = @@operators.values.map(&:to_s)
    ts.split.map do |token|
      ops.include?(token) ? token.intern : token.to_f
    end
  end
  
  def evaluate s
    tokens(s).each do |token|
      if token.is_a? Symbol
        do_operation token
      else
        push token
      end
    end
    @stack.pop
  end
end
