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
require "./lib/cypher"
require "./lib/player"
require "./lib/computer"

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

def intro()
  output = <<~HERE
  Welcome to RBMasterMind!  This game is in the spirit of the original 
  Mastermind game originally created by Mordecai Meirowitz in the
  early 1970s.  The original game used colored marbles to represent
  a cyper.  A typical game used 4 empty slots with 6 colors of marble
  to choose from and a 'clues' area where the player would be notified 
  after their guess as to whether or not they chose a colored marble 
  in the sequence and if so whether it is in the correct position or not.  
  
  To simplify the game here, we will use numbers in the range 1 - 6 
  to choose from and the game will default to four (4) empty slots.
  You will receive feedback in the form of a clue response after you guess. 
  If you guess a number that is in the code you will receive one of two
  feedbacks:
    ● - You have guessed a number that is in the sequence and is in 
        the correct position. 
    ○ - You have guessed a number that is in the sequence but it is
        in the wrong position.
  
  We have set sane defaults for the game:
    - Duplicates within the code are off
    - Blank spaces within the code are off
    - Default length of the code is 4
  
  However, you may alter that if you wish.
  HERE
end

def validate_answer(opt1, opt2)
  # yes/no validation
  if opt1.is_a?(String) && opt2.is_a?(String)
    string_choice = ""
    until %w[y n].include?(string_choice)
      puts "Please choose y or n."
      string_choice = gets.downcase.chomp
    end
    string_choice == opt1
    # int range validation
  elsif opt1.is_a?(Integer) && opt2.is_a?(Integer)
    integer_choice = 0
    until integer_choice.between?(opt1, opt2)
      puts "Please enter an integer between 8 and 12"
      integer_choice = gets.chomp.to_i
    end
    integer_choice
  else
    puts "Invalid input for validation"
  end
end

def get_code_length()
  len = 0
  until len.between?(1, 6)
    puts "How long should the code cypher be? (Default is 4)"
    puts "May be up to 6 in length"
    len = gets.chomp.to_i
    len = 4 if len == 0
  end
  len
end

def configure_gameplay()
  responses = {}
  puts "Should we allow duplicate numbers in the code? "
  responses[:allow_duplicates] = validate_answer("y", "n")
  puts "should we allow blanks in the code? "
  responses[:allow_blanks] = validate_answer("y", "n")
  puts "How many attempts should be allowed? "
  responses[:total_attempts] = validate_answer(8, 12)
  responses[:cypher_length] = get_code_length()
  responses[:role] = set_roles()
  responses
end

def set_roles()
  response = ""
  until %w[maker breaker].include?(response)
    puts "Please choose a role of either Code Maker or Code Breaker."
    puts "Enter 'Maker' or 'Breaker': "
    response = gets.downcase.chomp
  end
  response
end

=begin
Game play if breaker:
Computer generates a cypher then begin turns

- Anatomy of a turn
  Guess phase: Player guesses a cypher
  Clue phase: computer checks cypher for win state and gives clues

this repeats for N number of turns until either a win condition is met and breaks the loop
or N = turns
=end

def breaker(player)
  code =
    Cypher.new(
      player.config[:allow_duplicates],
      player.config[:allow_blanks],
      player.config[:cypher_length],
    )
  code.breaker_generate()
  code
end

=begin
Game play if maker:
Player picks a cypher then begin turns

- Anatomy of a turn
  Guess phase: Computer guesses a cypher
  Clue phase: computer checks cypher for win state and gives clues

this repeats for N number of turns until either a win condition is met and breaks the loop
or N = turns
=end

def maker(player)
  # prompt player to create cypher
  code =
    Cypher.new(
      player.config[:allow_duplicates],
      player.config[:allow_blanks],
      player.config[:cypher_length],
    )
  code.maker_generate()
  code
end

def choose_role(player)
  # options[:turns]
  if player.config[:role] == "breaker"
    code = breaker(player)
  else
    code = maker(player)
  end
  code
end

def game_loop(player, code)
  turns = player.config[:total_attempts]
  puts "Loading computer opponent"
  computer_opponent = Computer.new()
  win_state = false
  while turns > 0 && !win_state
    if player.config[:role] == "maker"
      # Computer needs to formulate a guess, then determine positions then determine win state.
      determine_positions(computer_opponent.guess(player.config, code))
    else
      # Player needs to guess, then determine positions then determine win state
      determine_positions(player_guess(player.config, code))
    end
    turns -= 1
  end
end

def main()
  puts intro()
  print "Please enter your name when you are ready to begin: "
  name = gets.chomp
  player = Player.new(name)
  player.config = configure_gameplay()
  code = choose_role(player)
  game_loop(player, code)
end

main()
