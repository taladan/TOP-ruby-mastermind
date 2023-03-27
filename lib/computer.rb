# lib/computer.rb
require_relative "state"
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

  def guess(config, code)
    guess = 
  end

  private

  def create_pool()
    binding.pry
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

#   def master_mind(length, mastermind_code)
#     if length == 2
#       use_pool = @guess_pool[:cart_2]
#     elsif length == 3
#       use_pool = @guess_pool[:cart_3]
#     elsif length == 4
#       use_pool = @guess_pool[:cart_4]
#     elsif length == 5
#       use_pool = @guess_pool[:cart_5]
#     else
#       use_pool = @guess_pool[:cart_6]
#     end

#     total_codes = use_pool
#     knuth_codes = total_codes
#     possible_codes = total_codes
#     total_guesses = 0
#     win_state = false

#     while win_state == false
#       code = get_code(knuth_codes, possible_codes)
#       # delete this and the feedback puts when complete
#       feedback = State.computer_check_positions(code, mastermind_code)
#       # Need to figure out how to integrate the returned values of positioning into this
#       if feedback == (cp == length && wp == 0)
#         total_guesses += 1
#         win_state = true
#         break
#       else
#         prune_list(code, feedback, knuth_codes)
#         total_guesses += 1
#       end
#     end
#     total_guesses
#   end

#   def get_code(knuth_codes, possible_codes)
#     guess_codes = mini_max(knuth_codes, possible_codes)
#     code = get_guess_code_from_list(knuth_codes, guess_codes)
#     possible_codes.delete(code)
#     code
#   end

#   def mini_max(knuth_codes, possible_codes)
#     times_found = Hash.new(0)
#     scores = Hash.new(0)
#     guess_codes = []
#     possible_codes.each do |code|
#       knuth_codes.each do |code_to_crack|
#         # here's where we need State.check_positions
#         feedback = State.computer_check_positions(code_to_crack, code)
#         times_found[feedback] += 1
#       end
#       maximum = times_found.max_by { |key, value| value }
#       scores[code] = maximum
#     end
#     puts scores
#     minimum = scores.min_by { |key, value| value }

#     possible_codes.each do |code|
#       guess_codes.push(code) if scores[code] == minimum
#     end
#     guess_codes
#   end

#   def prune_list(last_guess, feedback, knuth_codes)
#     knuth_codes.each do |code|
#       retrieved_feedback = State.computer_check_positions(code, last_guess)
#       knuth_codes.delete(code) if retrieved_feedback != feedback
#     end
#   end

#   def get_guess_code_from_list(knuth_codes, guess_codes)
#     found_code = nil
#     knuth_codes.each do |code|
#       if guess_codes.include?(code)
#         found_code = code
#         break
#       else
#         guess_codes.first()
#       end
#     end
#   end
# end
