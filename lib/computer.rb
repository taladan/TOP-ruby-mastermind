# lib/computer.rb
require_relative "solver"
require "pry-byebug"

#
##  Thing to remember: Array.permutation is faster than .product of multiple arrays
#

#  I want to revisit this class and trim it down some.  I want to reimplement how it
# is generating the pool of valid guesses - the marshal files feel a little kludgy to me.
# I'm also wanting to try and apply what I've learned from implementing the minimax class in
# minimax.rb to this class so that it can determine valid numbers to guess from when rebuilding
# the set of guesses.

# I need to flowchart the Knuth algorightm so that I understand each step of it.

class Computer
  attr_accessor :guess_pool

  def initialize(config)
    # Config opts:
    #   [:allow_duplicates]
    #   [:allow_blanks]
    #   [:total_attempts]
    #   [:cypher_length]
    @config = config
    @guess_pool = create_pool()
    @initial_guess =
      ("1" * (config[:cypher_length] / 2)) +
        ("2" * (config[:cypher_length] - (config[:cypher_length] / 2)))
  end

  def guess(code)
    guess = @initial_guess
    pool = @guess_pool.clone
    solver = Solver.new(pool, code)

    turn = 0
    while pool.length > 1 && turn < @config[:total_attempts]
      feedback = solver.get_feedback(guess, code)
      if feedback[:cp] < code.length
        pool = solver.reduce_solutions(guess, feedback, pool)
        if pool.length > 2
          guess = pool.last
        elsif pool.length == 2
          if pool[0] == code
            pool = pool[0]
          else
            pool = pool[1]
          end
          break
        end
        turn += 1
      elsif feedback[:cp] == code.length
        pool = guess
        break
      end
    end
    pool = pool.join if pool.is_a?(Array)
    result = [pool, turn + 1]
  end

  private

  def create_pool()
    base_pool = %w[1 2 3 4 5 6]

    @config[:allow_blanks] ? base_pool.push(" ") : base_pool

    if @config[:allow_duplicates]
      pool = base_pool.repeated_permutation(@config[:cypher_length]).to_a
    else
      pool = base_pool.permutation(@config[:cypher_length]).to_a
    end
    pool
  end
end
