# lib/determine_positions.rb

module State
  def self.computer_check_positions(code_to_crack, code)
    output = { correct_position: 0, wrong_position: 0 }
    code_to_crack = code_to_crack.split("") if code_to_crack.is_a?(String)
    code = code.split("") if code.is_a?(String)

    if code_to_crack == code
      output[:correct_position] = code_to_crack.length
      return output
    else
      code.each_with_index do |check_position, cp_idx|
        code_to_crack.each_with_index do |position, p_idx|
          if code_to_crack.include?(check_position) && cp_idx == p_idx
            output[:correct_position] += 1
          elsif code_to_crack.include?(check_position)
            output[:wrong_position] += 1
          end
        end
      end
    end
    output
  end

  # check state is a bad name.  We are comparing the guess to the code.

  # compare_guess_to_original_code -> give feedback
  # guess is an array of strings, cypher is an array of strings
  # for each element in guess, if it is in cypher and in the same position in cypher that it is
  # in guess, that element adds to the 'correct_position' value in a tracking hash.  If the element
  # is in the cypher but isn't in the same position in cypher as it is in guess, it adds to the 'wrong_position' value
  # in the tracking hash.
  # feedback is the value of the hash.

  def self.compare_guess_to_code(guess, cypher)
    feedback = { cp: 0, wp: 0 }
    guess = make_array(guess)
    cypher = make_array(cypher)

    # guard
    return feedback if (guess & code).length == 0

    guess.each_with_index do |position, guess_index|
      code_index = code.find_index(position)
      if guess_index == code_index
        feedback[:cp] += 1
      elsif code_index
        feedback[:wp] += 1
      end
    end
    feedback
  end

  def self.check_positions(player_guess, cypher)
    working_cypher = cypher.clone
    wrong_position = "\u25cb"
    correct_position = "\u25cf"
    wrong_guess = " "

    # if player_guess.is_a?(Array)
    #   guess_array = player_guess
    # else
    #   guess_array = player_guess.split("")
    # end

    results = []
    guess_array.each_with_index do |guess, guess_index|
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

  def make_array(obj)
    if obj.is_a?(Array)
      return obj
    elsif obj.is_a?(String)
      return obj.split("")
    end
  end
end
