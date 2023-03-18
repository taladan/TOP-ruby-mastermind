# Mastermind
# A game based off of a pencil and paper game called "Bulls and Cows".
# The rules to Mastermind:
# - There is a hidden cypher selected, either by the computer or the player.
# - The default cypher is of length 4, but should be adjustable to any length.
# - Player gets 8-12 guesses (configurable before game start)
# - Duplicates and Blanks within the cypher are disallowed by default,
#   but a player may choose to allow them for added difficulty
# - When a player guesses a number (corresponds to color guesses in the original mastermind)
#   the will receive an indicator in the form of a filled circle if the number is in the same
#   position within the cyper, or an empty circle if it is in the cypher but not in the same
#   position.
# - The results will be displayed to the player of their guess, with wrong guesses being empty
#   and the results will be shuffled to keep from indicating which number is correct in which
#   position

# Game Defaults
allow_duplicates = false
allow_blanks = false
total_attempts = 0

def determine_positions(guess_array, cypher)
  working_cypher = cypher.clone
  right_guess_wrong_space = "\u25cb"
  right_guess_right_space = "\u25cf"
  wrong_guess = " "

  results = []
  guess_array.each_with_index do |guess, guess_index|
    if working_cypher.include?(guess)
      if guess == working_cypher[guess_index]
        results.push(right_guess_right_space)
        working_cypher[guess_index] = "replaced"
      else
        results.push(right_guess_wrong_space)
        working_cypher[working_cypher.index(guess)] = "replaced"
      end
    else
      results.push(wrong_guess)
    end
  end
  # Remove blank strings and shuffle results for return
  results.delete(" ")
  results.shuffle()
end

def random_number_generator(choice = 4)
  # Returns an array of 4 random numbers between 1 and 6 (inclusive)
  code_array = []
  choice.times { |i| code_array.push(rand(1..6)) }
  code_array
end

cypher = random_number_generator(12)
puts cypher
