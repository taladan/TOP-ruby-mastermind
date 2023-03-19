# lib/cypher.rb
#

class Cypher
  def initialize(duplicates, blanks, length)
    @duplicates = duplicates
    @blanks = blanks
    @length = length
  end

  def generate()
    # Returns an array of 4 random numbers between 1 and 6 (inclusive)
    cypher = []
    if @blanks
      valid_pool = [1, 2, 3, 4, 5, 6, " "]
    else
      valid_pool = [1, 2, 3, 4, 5, 6]
    end

    if @duplicates
      @length.times { |i| cypher.push(valid_pool.sample()) }
    else
      @length.times { |i| cypher = valid_pool.sample(@length) }
    end
    cypher
  end
end
