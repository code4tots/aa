

def rps human_choice
  win_table = {
    "Rock" => "Scissors",
    "Scissors" => "Paper",
    "Paper" => "Rock"
  }
  choices = win_table.keys
  computer_choice = choices.sample
  
  "#{computer_choice}, " +
  if computer_choice == human_choice
    "Draw"
  elsif win_table[computer_choice] == human_choice
    "Lose"
  else
    "Win"
  end
end

# p rps("Rock") # => "Paper, Lose"
# p rps("Scissors") # => "Scissors, Draw"
# p rps("Scissors") # => "Paper, Win"

def remix pairs
  col1, col2 = pairs.transpose
  new_col2 = col2.shuffle
  while new_col2.zip(col2).any? { |newer,original| newer == original }
    new_col2 = col2.shuffle
  end
  col1.zip(new_col2)
end

p remix([
  ["rum", "coke"],
  ["gin", "tonic"],
  ["scotch", "soda"]
])
#=> [["rum, "tonic"], ["gin", "soda"], ["scotch", "coke"]]

