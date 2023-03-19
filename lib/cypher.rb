# lib/cypher.rb
#

class Cypher
  attr_reader :cypher
  def initialize(duplicates, blanks, length)
    @duplicates = duplicates
    @blanks = blanks
    @length = length
    @cypher = ""
  end

  def breaker_generate()
    # Returns an array of 4 random numbers between 1 and 6 (inclusive)
    cypher = []
    valid_pool = set_pool()

    if @duplicates
      @length.times { |i| cypher.push(valid_pool.sample()) }
    else
      @length.times { |i| cypher = valid_pool.sample(@length) }
    end
    @cypher = cypher
    cypher
  end

  def maker_generate()
    cypher = []
    valid_pool = set_pool()

    if @duplicates
      @length.times do |i|
        clear_screen()
        choice = validate_choice(valid_pool)
        puts "Adding #{choice} to code."
        cypher.push(choice)
        sleep(1)
      end
      # remove members of the pool when prompting
    else
      @length.times do |i|
        clear_screen()
        choice = validate_choice(valid_pool)
        puts "Adding #{choice} to code."
        cypher.push(choice)
        _ = valid_pool.delete(choice)
        sleep(1)
      end
    end
    @cypher = cypher
    cypher
  end

  private

  def clear_screen()
    system("clear") || system("cls")
  end

  def validate_choice(pool)
    choice = ""
    until pool.include?(choice)
      puts "Please choose a segment to add from #{pool.join(", ")}."
      puts "(If you have allowed blank spaces in the code, you can hit SPACEBAR to add one)"
      choice = gets.chomp
    end
    choice
  end

  def set_pool()
    if @blanks
      pool = ["1", "2", "3", "4", "5", "6", " "]
    else
      pool = %w[1 2 3 4 5 6]
    end
    pool
  end
end
