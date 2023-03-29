# lib/player.rb
#
# Stores player configured game data and handles player's 'turns'

require_relative "solver"

class Player
  attr_accessor :name, :config
  def initialize(name)
    @name = name
    @config = {}
    # @guess[:1] = ["4635", "●○"]
    @guesses = {}
  end

  def guess(pool)
    turns = @config[:total_attempts]
    code = @config[:cypher]
    solver = Solver.new(pool, code)
    guess = prompt_for_guess(pool)
    feedback = solver.get_feedback(guess, code)
    win_state = false

    turn = 1
    while feedback[:cp] < @config[:cypher_length] && turn < turns && !win_state
      puts "●" * feedback[:cp] + "○" * feedback[:wp]
      guess = prompt_for_guess(pool)
      feedback = solver.get_feedback(guess, code)
      win_state = true if feedback[:cp] == @config[:cypher_length]
      turn += 1
    end

    puts "You guessed the cypher in #{turn} turns!" if win_state && turn < turns
    puts "You took too many turns :(" if turn >= turns
  end

  def prompt_for_guess(pool)
    guess = nil
    if @config[:allow_blanks]
      regexp = /^[1-6 ]{#{@config[:cypher_length]}}$/
    else
      regexp = /^[1-6]{#{@config[:cypher_length]}}$/
    end

    until guess =~ regexp
      puts "Please enter a #{@config[:cypher_length]} length cypher."
      guess = gets.chomp
    end
    guess
  end
end
