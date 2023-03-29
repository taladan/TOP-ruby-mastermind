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

require "./lib/computer"
require "./lib/mastermind"

def game_loop(player, code)
  puts "Loading computer opponent."
  computer_opponent = Computer.new(player.config)
  if player.config[:role] == "maker"
    result = computer_opponent.guess(code.cypher)
    if result[1] < player.config[:total_attempts] &&
         result[0].split("") == code.cypher
      puts "The computer guessed your code was: #{result[0]}.  The cypher was: #{code.cypher.join}.  It made it in #{result[1]} guesses!"
    else
      puts "The computer took too many guesses!  You win #{player.name}!"
    end
  else
    player.guess(computer_opponent.guess_pool)
  end
end

def main()
  game = Mastermind.new()
  game_loop(game.player, game.code)
end

main()
