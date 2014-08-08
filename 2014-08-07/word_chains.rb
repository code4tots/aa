require 'set'
class WordChainer

  def initialize(dictionary_file_name='dictionary.txt')
    # Access file & store in @dictionary
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp).to_set
    initialize_dictionary_slice
    @neighbors = Hash.new
  end
  
  # Create key/values that pair words with length in @dictionary
  def initialize_dictionary_slice
    @dictionary_slice = Hash.new { [] }
    # Pair word size with word
    @dictionary.each do |word|
      @dictionary_slice[word.size] <<= word
    end
  end
  
  ### Super slow and stupid
  # def adjacent_words(word)
  #   # For words not included in neighbor
  #   unless @neighbors.include?(word)
  #     # Select from the dictionary/slice hash (containing words w/sizes)
  #     @neighbors[word] = @dictionary_slice[word.size].select do |maybe_neighbor|
  #       # candidate that is a neighbor (ie one letter diff w/ word)
  #       # Assign as value to key (word) in @neighbors
  #       are_neighbors?(word,maybe_neighbor)
  #     end
  #   end
  #   @neighbors[word]
  # end
  #
  # def are_neighbors?(word1,word2)
  #   # two words must be same size
  #   return false unless word1.size == word2.size
  #   # split each char of word to array
  #   word1 = word1.each_char.to_a
  #   word2 = word2.each_char.to_a
  #   number_of_differences = 0
  #   # pairs up characters from word 1 & word 2
  #   word1.zip(word2).each do |character1, character2|
  #     # Track number of differences if characters do not match up
  #     number_of_differences += 1 if character1 != character2
  #   end
  #   # only select pairs that have one difference in character
  #   number_of_differences == 1
  # end
  
  
  Solution
  def adjacent_words(word)
    adjacent_words = []
    
    # each char & its index in word
    word.each_char.with_index do |old_letter, i|
      # Iterate through alphabet
      ('a'..'z').each do |new_letter|
        # Next if the alphabet letter is the same as char (of word) 
        next if old_letter == new_letter
        # create copy of word
        new_word = word.dup
        # replace with alphabet letter
        new_word[i] = new_letter
        # push to adjacent words if the word exists in the dictionary
        adjacent_words << new_word if @dictionary.include?(new_word)
      end
    end
    adjacent_words
  end
  
  # Way described on assignment
  def run(source, target)
    # Current words include your starting word
    @current_words = [source]
    # Create hash with source as key/value pair
    @all_seen_words = Hash[[[source,source]]]
    until @all_seen_words.include?(target)
      new_current_words = []
      # Iterate through the current words you have
      @current_words.each do |current_word|
        # p current_word
        # Filter current words that have not been seen
        explore_current_words(current_word,new_current_words)
      end
      # update @current_words
      @current_words = new_current_words
    end
    # Record all the words that you have seen
    @last_word = @all_seen_words
    build_path(source, target)
  end

  # Purpose is to filter out adjacent words that have also been seen & present 
  # an updated array of current_words back to run
  def explore_current_words(current_word,new_current_words)
    # Iterate through possible adjacent words of current word
    adjacent_words(current_word).each do |adjacent_word|
      # Unless the adjacent word has already been recorded
      unless @all_seen_words.include?(adjacent_word)
        # push (adjacent word) into new_current words (def in run)
        new_current_words << adjacent_word
        # create key/value pair in @all_seen_words with adjacent words
        @all_seen_words[adjacent_word] = current_word
      end
    end
  end
  
  # ## First time, ignoring instructions.
  # def run(source, target)
  #   # FIFO queue
  #   @current_words = [source]
  #   @all_seen_words = [source].to_set
  #   # last_word[word] is the word that you visited right before visitng word.
  #   @last_word = {}
  #   until @last_word.include?(target)
  #     word = @current_words.shift
  #     adjacent_words(word).each do |neighbor|
  #       unless @all_seen_words.include?(neighbor)
  #         @last_word[neighbor] = word
  #         @current_words << neighbor
  #         @all_seen_words << neighbor
  #       end
  #     end
  #   end
  #   build_path(source,target)
  # end
  
  # Build the path from the source word to the target word
  def build_path(source,target)
    path = [target]
    until path[-1] == source
      # Push to your path (array) the last el of @last_word
      path << @last_word[path[-1]]
    end
    path.reverse
  end
  
  
  
end


wc = WordChainer.new
p wc.run('abbreviate','acrobatics')
