# solver.rb

=begin
   When we get to the point that we are trying to reduce the pool of numbers, we're going to take
   S = set of all possible solutions
   g = current_guess
   secret = '3344' (some cyper of length n)

   g = 1122
   feedback(g,code) -> against secret, g will return no correct positions

   feedback(S, g) -> 
   iterate through set of all possible solutions (ps), any solution in the set of all possible solutions
   that gives the SAME feedback as the original should be stored in the next set of possible solutions - because we
   are comparing each solution to the initial guess, if it gives 'no correct positions' as feedback, that will mean it
   is a set encompassing all numbers that exclude the values '1' and '2'.
=end

class Solver
  def initialize(possible_solutions, code)
    @possible_solutions = possible_solutions
    @code = code
  end

  def reduce_solutions(guess, previous_feedback, possible_solutions)
    return possible_solutions if possible_solutions.length <= 2

    solutions = []
    possible_solutions.each_with_index do |solution, index|
      feedback = get_feedback(guess, solution)
      solutions.push(possible_solutions[index]) if feedback == previous_feedback
    end
    binding.pry
    solutions
  end

  def get_feedback(guess, possible_solution)
    feedback = { cp: 0, wp: 0 }
    guess = make_array(guess)
    possible_solution = make_array(possible_solution)
    possible_solution_working_copy = possible_solution.clone

    # guard
    return feedback if (guess & possible_solution).length == 0

    guess.each_with_index do |position, guess_index|
      code_index = possible_solution_working_copy.find_index(position)
      if guess_index == code_index
        feedback[:cp] += 1
        possible_solution_working_copy[code_index] = nil
      elsif code_index
        feedback[:wp] += 1
      end
    end
    feedback
  end

  def make_array(obj)
    if obj.is_a?(Array)
      return obj
    elsif obj.is_a?(String)
      return obj.split("")
    end
  end
end
