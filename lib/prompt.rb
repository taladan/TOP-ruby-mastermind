# lib/prompt.rb
#
# Prompts user for input and returns the validated input
require_relative "messaging"

class Prompt
  include Messaging
  def initialize
    load_queries()
    @default_delay = 0.002
  end

  def query(question)
    case question
    when "intro"
      Messaging.clear_screen()
      write(@intro, @default_delay)
      response = gets.chomp
    when "length"
      Messaging.clear_screen()
      write(@code_length_query, @default_delay)
      response = validate_answer(2, 6, 4)
    when "duplicates"
      Messaging.clear_screen()
      write(@allow_duplicates_query, @default_delay)
      response = validate_answer("y", "n")
    when "blanks"
      Messaging.clear_screen()
      write(@allow_blanks_query, @default_delay)
      response = validate_answer("y", "n")
    when "attempts"
      Messaging.clear_screen()
      write(@total_attempts_query, @default_delay)
      response = validate_answer(8, 12, 12)
    when "role"
      Messaging.clear_screen()
      write(@role_query, @default_delay)
      response = validate_answer("Maker", "Breaker")
    end
    response
  end

  def validate_answer(opt1, opt2, default = false)
    # String validation
    if opt1.is_a?(String) && opt2.is_a?(String)
      string_choice = ""
      until ["#{opt1.downcase}", "#{opt2.downcase}"].include?(string_choice)
        write("Please choose #{opt1} or #{opt2}: ", @default_delay)
        string_choice = gets.downcase.chomp
      end
      opt1 == "y" ? string_choice == opt1 : string_choice

      # int range validation
    elsif opt1.is_a?(Integer) && opt2.is_a?(Integer)
      integer_choice = 0
      until integer_choice.between?(opt1, opt2)
        write(
          "Please enter an integer between #{opt1} and #{opt2}: ",
          @default_delay,
        )
        integer_choice = gets
        if default && integer_choice == "\n"
          integer_choice = default
        else
          integer_choice = integer_choice.chomp.to_i
        end
      end
      integer_choice
    else
      write("Invalid input for validation", @default_delay)
    end
  end

  private

  def load_queries
    @intro = <<~HERE
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
      Please enter your name when you are ready to begin: 
      HERE
    @code_length_query = "How long should the code cypher be? (Defaults to 4) "
    @allow_duplicates_query = "Should we allow duplicate numbers in the code? "
    @allow_blanks_query = "Should we allow blanks in the code? "
    @total_attempts_query =
      "How many attempts should be allowed? (Defaults to 12) "
    @role_query = "Please choose a role of either Code Maker or Code Breaker. "
  end
end
