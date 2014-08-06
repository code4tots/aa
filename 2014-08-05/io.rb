class GuessingGame
  def initialize(options={})
    defaults = {
      :max_guess => 100,
      :min_guess => 1
    }
    options = defaults.merge(options)
    
    @max_guess = options[:max_guess]
    @min_guess = options[:min_guess]
    @special_number = (1..100).to_a.sample
  end
  
  def start_game
    puts "Welcome to our guessing game!!!"
    run_game
  end
  
  private
  def run_game
    guess = gets.to_i
    case guess
    when @special_number
      puts "You win!!!!"
    when @min_guess...@special_number
      puts "Too small"
      run_game
    when @special_number..@max_guess
      puts "Too big"
      run_game
    else
      puts "Invalid number pick one from 1..100"
      run_game
    end
  end
end

# GuessingGame.new.start_game

########################################
#### RPN Calculator is under new_rpn.rb
########################################

################################################
#### Line shuffling program is under shuffle.rb
################################################

