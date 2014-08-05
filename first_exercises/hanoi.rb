class Hanoi
  def initialize
    @number_of_disks = 3
    @disks = [@number_of_disks.times.map{|i|i+1}.reverse, [], []]
  end
  
  def done
    @disks[2].size == @number_of_disks
    
  end
  
  def ask prompt
    print(prompt)
    x = gets.to_i 
    return x if (1..3).include?(x)
    puts "Valid selection, please"
    ask(prompt)
 end
  
  def run
    while !done
      p @disks
      from = ask('where from? ').to_i - 1
      to   = ask('where to?   ').to_i - 1
      if @disks[from].size == 0
        puts "No disk there"
      elsif @disks[to].size == 0 || @disks[from][-1] < @disks[to][-1]
        @disks[to] << @disks[from].pop
      else
        puts "Destination disk is too small"        
      end
      
    end
    puts "Congrats!"
  end
end

Hanoi.new.run
