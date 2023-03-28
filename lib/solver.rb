# solver.rb

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
    solutions
  end

  def get_feedback(guess, code)
    feedback = { cp: 0, wp: 0 }
    guess_array = make_array(guess)
    code = make_array(code)
    code_working_copy = code.clone

    # guard
    return feedback if (guess_array & code_working_copy).length == 0

    guess_array.each_with_index do |element, guess_index|
      code_index_value = code_working_copy[guess_index]
      if element == code_index_value
        feedback[:cp] += 1
        guess_array[guess_index] = "ran"
        code_working_copy[guess_index] = "nar"
      end
    end
    guess_array.each do |element|
      feedback[:wp] += 1 if code_working_copy.include?(element)
    end
    feedback

    # guess.each_with_index do |position, guess_index|
    #   code_index = code_working_copy.find_index(position)
    #   if guess_index == code_index
    #     feedback[:cp] += 1
    #   elsif code_index
    #     feedback[:wp] += 1
    #   end
    #   binding.pry
    #   code_working_copy[code_index] = 0 if code_index
    # end
    # feedback
  end

  private

  def make_array(obj)
    if obj.is_a?(Array)
      return obj
    elsif obj.is_a?(String)
      return obj.split("")
    end
  end
end
