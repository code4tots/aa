class Mastermind
  
  attr_reader :code, :guess, :exact, :near
  
  def initialize 
    generate_code
  end
  
  def generate_code
    @code = Code.new
    @code.generate_code
  end
  
  def get_guess
    print("Enter a guess: ")
    @guess = @code.parse_code(gets.strip)
    unless guess.nil?
      @guess_count += 1
      return @guess
    end
    
    puts "Invalid guess... must be 4 capital letters representing colors"
    @code.display_colors
    get_guess
  end
  
  def display_result
    puts "#{@exact.size} exact"
    puts "#{@near.size} near"
  end
  
  def play
    @guess_count = 0
    generate_code
    until 10 == @guess_count || @exact == (0...4).to_a
      get_guess
      @exact, @near = @code.check_guess(@guess)
      display_result
    end
    
    puts "The code was: #{@code}"
    
    if @guess_count == 10
      puts "Sorry :("
    else
      puts "Victory!!!!"
    end
  end
  
end

class Code
  COLORS = [:red, :green, :blue, :yellow, :orange, :purple]
  COLOR_LETTERS = Hash[COLORS.map { |color| [color[0].upcase, color] }]
  
  def generate_code
    @code = 4.times.map { COLORS.sample }
  end
  
  def parse_code code
    code = code.strip
    return nil unless code.length == 4
    letters = code.split('')
    letters_valid = letters.all? { |c| COLOR_LETTERS.include?(c) }
    return nil unless letters_valid
    
    letters.map { |c| COLOR_LETTERS[c] }
  end
  
  def check_guess(guess)
    guess = guess.dup
    code = @code.dup
    exact = [] # positions, exactly matched
    near = [] # colors that were correct, but wrong position
    (0...4).each do |position|
      if code[position] == guess[position]
        exact << position
        guess[position] = code[position] = nil
      end
    end
    
    COLORS.each do |color|
      count = [guess.count(color),code.count(color)].min
      count.times do
        near << color
      end
    end
    [exact, near]
  end

  def display_colors
    puts "available colors are"
    COLOR_LETTERS.each do |letter, color|
      puts "(#{letter}) #{color}"
    end
  end
  
  def to_s
    @code.map { |color| color[0].upcase }.join
  end
  
end

game = Mastermind.new
game.play

