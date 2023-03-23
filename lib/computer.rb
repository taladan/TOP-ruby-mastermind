# lib/computer.rb
require_relative "player"
require_relative "state"

class Computer < Player
  attr_accessor :guess_pool

  def initialize
    super(@guesses)
    @guess_pool = load_pools()
  end

  def guess(config, code)
    # pool = generate_pool(config[:cypher_length], config[:allow_duplicates], config[:allow_blanks])
    master_mind(config[:cypher_length], code)
  end

  private

  def load_pools()
    pools = {
      cart_2: Marshal.load(File.read("./lib/cart_2.dump")),
      cart_3: Marshal.load(File.read("./lib/cart_3.dump")),
      cart_4: Marshal.load(File.read("./lib/cart_4.dump")),
      cart_5: Marshal.load(File.read("./lib/cart_5.dump")),
      cart_6: Marshal.load(File.read("./lib/cart_6.dump")),
    }
    pools
  end

  def master_mind(length, mastermind_code)
    if length == 2
      use_pool = @guess_pool[:cart_2]
    elsif length = 3
      use_pool = @guess_pool[:cart_3]
    elsif length = 4
      use_pool = @guess_pool[:cart_4]
    elsif length = 5
      use_pool = @guess_pool[:cart_5]
    else
      use_pool = @guess_pool[:cart_6]
    end

    total_codes = use_pool
    knuth_codes = total_codes
    possible_codes = total_codes
    total_guesses = 0
    win_state = false

    while win_state == false
      code = get_code(knuth_codes, possible_codes)
      feedback = State.check_positions(code, mastermind_code)
      # Need to figure out how to integrate the returned values of positioning into this
      puts feedback
      if feedback == (cp == length && wp == 0)
        total_guesses += 1
        win_state = true
        break
      else
        prune_list(code, feedback, knuth_codes)
        total_guesses += 1
      end
    end
    total_guesses
  end

  def get_code(knuth_codes, possible_codes)
    guess_codes = mini_max(knuth_codes, possible_codes)
    code = get_guess_code_from_list(knuth_codes, guess_codes)
    possible_codes.delete(code)
    code
  end

  def mini_max(knuth_codes, possible_codes)
    times_found = Hash.new(0)
    scores = Hash.new(0)
    guess_codes = []
    possible_codes.each do |code|
      knuth_codes.each do |code_to_crack|
        # here's where we need State.check_positions
        feedback = State.check_positions(code_to_crack, code)
        times_found[feedback] += 1
      end
      maximum = times_found.max_by { |key, value| value }
      scores[code] = maximum
    end
    minimum = scores.min_by { |key, value| value }

    possible_codes.each do |code|
      guess_codes.push(code) if scores[code] == minimum
    end
    guess_codes
  end

  def prune_list(last_guess, feedback, knuth_codes)
    knuth_codes.each do |code|
      retrieved_feedback = State.check_positions(code, last_guess)
      knuth_codes.delete(code) if retrieved_feedback != feedback
    end
  end

  def get_guess_code_from_list(knuth_codes, guess_codes)
    found_code = nil
    knuth_codes.each do |code|
      if guess_codes.include?(code)
        found_code = code
        break
      else
        guess_codes.first()
      end
    end
  end
end
