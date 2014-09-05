class RPNCalculator 
  
    def initialize
        @stack = [0]    
    end
 
    def value
        @stack.last
    end
 
    def pop
        n = @stack.pop
        raise "calculator is empty" if n.nil?
        n
    end
 
 
    def push(n=@value)  
        @stack.push(n)
    end
 
    def plus
        first = pop
        second = pop
        push(first + second)    
    end
 
    def minus
        subtractant = pop
        push(pop - subtractant)    
    end
 
    def divide
        divisor = pop
        push(pop.to_f / divisor.to_f)    
    end
 
    def times
        push(pop * pop)    
    end
 
    def tokens(str)
        operators = [ '+', '-', '*', '/' ]
        str.split(' ').map { |e| e = operators.include?(e) ? e.to_sym : e.to_i }
    end
 
    def evaluate(str)
        nonNumbers = [ '+', '-', '*', '/', ' ' ]
 
        len = str.length
        i = 0
        while i < len 
            if nonNumbers.include?(str[i]) 
                case str[i]
                when '+' then plus
                when '-' then minus
                when '*' then times
                when '/' then divide
                else
                end
            else
                push(str[i].to_i)
            end
            i += 1
        end
     
        return value
    end
end

if __FILE__ == $PROGRAM_NAME
  calculator = RPNCalculator.new
  if ARGV[0] == nil
    puts "Manually write your code"
    while true
      user_input = gets.chomp
      calculator.evaluate(user_input)
      puts calculator.pop
    end
  
  else
    File.open(ARGV[0]).readlines.each do |user_input|
      calculator.evaluate(user_input.chomp)
      puts calculator.pop
    end
  end
end
