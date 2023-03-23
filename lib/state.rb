# lib/determine_positions.rb

module State
  def self.check_positions(player_guess, cypher)
    working_cypher = cypher.clone
    wrong_position = "\u25cb"
    correct_position = "\u25cf"
    wrong_guess = " "

    if player_guess.is_a?(Array)
      guess_array = player_guess
    else
      guess_array = player_guess.split("")
    end

    results = []
    guess_array.each_with_index do |guess, guess_index|
      puts "GUESS: #{guess}"
      puts "WORKING_CYPER: #{working_cypher}"
      if working_cypher.include?(guess)
        if guess == working_cypher[guess_index]
          results.push(correct_position)
          working_cypher[guess_index] = "replaced"
        else
          results.push(wrong_position)
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
end
