require 'logger'

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

  def init_game
    @guesses = 0
    word_length = @picker.pick_secret_word
    @used_letters = []
    @known_letters = '_' * word_length
    @picker.init(self)
    @guesser.init(self)
  end

  def play
    init_game

    until @guesses == @max_guesses || word_completed?
      letter = @guesser.guess
      response = @picker.check_guess(letter)
      @guesser.handle_guess_response(response)

      if response.empty?
        @guesses += 1
      end
    end

    end_game
    word_completed?
  end

  def end_game
    if word_completed?
      @guesser.won
    else
      @guesser.lost(@picker.results)
    end
  end

  def word_completed?
    !@known_letters.include?('_')
  end

  def guesses_left
    @max_guesses - @guesses
  end
end

class Player
  attr_accessor :hangman

  def init hangman
    self.hangman = hangman
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
    @hangman.guesses_left
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
    secret_length = gets.to_i

    if secret_length < 1
      puts "0 characters does not a word make"
      pick_secret_word
    end

    secret_length
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
      invalid_input
      self.guess
    end
  end

  def check_guess letter
    puts "So it's '#{known_letters}' so far right?"
    puts "And I got #{guesses_left} guesses left"
    puts "The other player guessed: #{letter}"
    print "Type in the positions the letter appears in: "
    
    line = gets
    while line =~ /[^\s0-9]/
      puts "Bad input. Try again."
      line = gets
    end
    
    positions = line.split.map(&:to_i)
    
    
    unless positions.size < tokens.size || valid_positions(positions)
      invalid_input
      check_guess(letter)
    end

    positions
  end
  
  def invalid_input 
    puts '######################################'
    puts '########## Invalid input #############'
    puts '######################################' 
  end

  def valid_positions? positions
    positions.select do |index| 
      index >= known_letters.length
    end.empty?
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

  def init hangman
    super
    @cut_dictionary = @dictionary[known_letters.size].dup
  end

  def initialize(options = {})
    defaults = {
      dictionary_filename: 'dictionary.txt',
      log_filename: 'hangman-computer.log'
    }
    values = defaults.merge(options)
    
    @log = Logger.new(values[:log_filename])
    
    @dictionary = Hash.new { [] }
    @flat_dictionary = []
    File.readlines(values[:dictionary_filename]).each do |line|
      line = line.strip
      @dictionary[line.size] <<= line
      @flat_dictionary << line
    end
  end

  def pick_secret_word
    @word = @flat_dictionary.sample
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
    STDERR.puts "You used '#{secret_word}'? That's so cheap"
  end

  def most_common_letter
    table = frequency_of_letters

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
    
    # @log.debug("matching words : #{matching_words}")
    # @log.debug("frequency of chars : #{frequency_table}")
    
    frequency_table
  end

  def matching_words
    @cut_dictionary.select! { |word| word_matches(word) }
    @cut_dictionary
  end

  def word_matches word
    # return false unless known_letters.size == word.size
    word.each_char.zip(known_letters.each_char.to_a).each do |c1, c2|
      return false if c2 != '_' && c1 != c2
    end
    true
  end
end

class VerboseComputer < ComputerPlayer
  def won
    super
    puts "I won with #{guesses_left} guesses_left"
  end
end
#
# Hangman.new(
#   ComputerPlayer.new,
#   ComputerPlayer.new
# ).play


Hangman.new(
  ComputerPlayer.new,
  HumanPlayer.new
).play

wins = 0
total = 1000

cpu1 = VerboseComputer.new
cpu2 = VerboseComputer.new

total.times do |n|
  game = Hangman.new(cpu1, cpu2)
  wins += 1 if game.play
  puts "#{wins} / #{n+1}"
end
puts "#{wins} / #{total}"

# 93 / 100
#
# real  0m22.441s
# user  0m22.246s
# sys  0m0.175s


# 91 / 100
#
# real  0m13.844s
# user  0m13.730s
# sys  0m0.114s


if __FILE__ == $PROGRAM_NAME
  require 'optparse'
  
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: hangman.rb [options]"
    
    opts.on("-g", "--guesses G", Integer, "Number of guesses per game") do |g|
      options[:guesses] = g
    end
    
    opts.on("-c", "--count C", Integer, "Number of games to repeat") do |c|
      options[:count] = c
    end
    
    
    
  end
  
  
  count = ARGV[1].nil? ? 7 : ARGV[1].to_i
  
  case ARGV[0]
  when nil
    
  when 'picker'
    Hangman.new(
      ComputerPlayer.new,
      HumanPlayer.new,
      :max_guesses => count
    ).play
  when 'guesser'
    Hangman.new(
      ComputerPlayer.new,
      HumanPlayer.new,
      :max_guesses => count
    ).play
  end
end
