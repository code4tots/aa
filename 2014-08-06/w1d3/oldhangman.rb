class Hangman
  attr_reader :max_guesses, :guesses
  attr_accessor :used_letters, :known_letters, :last_guess
  
  def initialize picker, guesser, options = {}
    @picker = picker
    @guesser = guesser
    defaults = {
      max_guesses: 7,
    }
    options = defaults.merge(options)
    
    @max_guesses = options[:max_guesses]
  end
  
  def play
    @guesses = 0
    @picker.hangman = @guesser.hangman = self
    
    word_length = @picker.pick_secret_word
    @guesser.receive_secret_length(word_length)
    
    @used_letters = []
    @known_letters = '_' * word_length
    
    until @guesses == @max_guesses || @picker.word_completed?
      letter = @guesser.guess
      response = @picker.check_guess(letter)
      @guesser.handle_guess_response(response)
      
      if response.empty?
        @guesses += 1
      end
    end
    
    if @picker.word_completed?
      @guesser.won
    else
      @guesser.lost(@picker.results)
    end
  end
end

class Player
  attr_accessor :max_guesses, :guesses, :hangman
  
  def guesses
    @hangman.guesses
  end
  
  def max_guesses
    @hangman.max_guesses
  end
  
  def known_letters
    @hangman.known_letters
  end
  
  def used_letters
    @hangman.used_letters
  end
  
  def last_guess
    @hangman.last_guess
  end
  
  def guesses_left
    max_guesses - guesses
  end
  
  def word_completed?
    !known_letters.include?('_')
  end
  
  def receive_secret_length secret_length
    @secret_length = secret_length
    @hangman.known_letters = '_' * secret_length
  end
  
  def update_known letter, positions
    positions.each do |position|
      known_letters[position] = letter
    end
  end
  
  def handle_guess_response positions
    used_letters << last_guess
    update_known last_guess, positions
  end
end

class HumanPlayer < Player
  def pick_secret_word
    puts "Pick a secret word in your head"
    print "Now type in the length of secret word: "
    @secret_length = gets.to_i
    puts "So it's #{@secret_length} eh?"
    @secret_length
  end
  
  def receive_secret_length secret_length
    super
    puts "The length of the word is #{secret_length}."
  end
  
  def guess
    puts "The known letters are : #{known_letters}"
    puts "#{guesses_left} guess(es) left"
    puts "Used letters: #{used_letters}"
    print "Guess a letter: "
    letter = gets.strip
    
    if validate(letter)
      @hangman.last_guess = letter
    else
      puts '######################################'
      puts '########## Invalid input #############'
      puts '######################################'
      self.guess
    end
  end
  
  def check_guess letter
    puts "So it's '#{known_letters}' so far right?"
    puts "And I got #{guesses_left} guesses left"
    puts "The other player guessed: #{letter}"
    print "Type in the positions the letter appears in: "
    positions = gets.split.map(&:to_i)
    update_known letter, positions
    
    positions
  end
  
  def handle_guess_response positions
    super
  end
  
  def results
    puts "What was the word?"
    gets.strip
  end
  
  def won
    puts "Congratulations!"
    puts "You correctly guessed '#{known_letters}'"
  end
  
  def lost secret_word
    puts "You lost!"
    puts "The word was: '#{secret_word}'"
  end
  
  private
  def validate letter
    ('a'..'z').include?(letter) && !used_letters.include?(letter)
  end
end

class ComputerPlayer < Player
  
  def initialize(dictionary_filename = 'dictionary.txt')
    super()
    @dictionary = []
    
    File.readlines(dictionary_filename).each do |line|
      @dictionary << line.strip
    end
  end
  
  def pick_secret_word
    @word = @dictionary.sample
    # @word = 'cat'
    @word.size
  end
  
  def check_guess(letter)
    positions = []
    @word.each_char.each_with_index do |c, index|
      positions << index if c == letter
    end
    positions
  end
  
  def guess
    @hangman.last_guess = most_common_letter
  end
  
  def results
    @word
  end
  
  def won
    puts "I WIN PUNY HUMAN THE WORD WAS #{known_letters}"
  end
  
  def lost secret_word
    puts "You used '#{secret_word}'? That's so cheap"
  end
  
  def most_common_letter
    table = frequency_of_letters
    # ptable
    unused_letters = ('a'..'z').to_a.reject do |letter|
      used_letters.include?(letter)
    end
    unused_letters.max_by { |letter| table[letter] }
  end
  
  def frequency_of_letters
    frequency_table = Hash.new(0)
    matching_words.each do |word|
      # if a letter appears more than once in a word, may have
      # unfair bias
      ('a'..'z').each do |letter|
        frequency_table[letter] += 1 if word.include?(letter)
      end
    end
    frequency_table
  end
  
  def matching_words
    @dictionary.select { |word| word_matches(word) }
  end
  
  def word_matches word
    return false unless known_letters.size == word.size
    word.each_char.zip(known_letters.each_char.to_a).each do |c1, c2|
      return false if c2 != '_' && c1 != c2
    end
    true
  end
end

game = Hangman.new(
  HumanPlayer.new,
  ComputerPlayer.new,
)

# game = Hangman.new(
#   ComputerPlayer.new,
#   HumanPlayer.new
# )
game.play