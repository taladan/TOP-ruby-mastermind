# lib/cypher.rb
#
require_relative "messaging"

class Cypher
  attr_reader :cypher
  include Messaging
  def initialize(duplicates, blanks, length)
    @duplicates = duplicates
    @blanks = blanks
    @length = length
    @cypher = ""
    @default_delay = 0.002
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
        Messaging.clear_screen()
        choice = validate_choice(valid_pool)
        write("Adding #{choice} to code.", @default_delay)
        cypher.push(choice)
        sleep(0.35)
      end
      # remove members of the pool when prompting
    else
      @length.times do |i|
        Messaging.clear_screen()
        choice = validate_choice(valid_pool)
        write("Adding #{choice} to code.", @default_delay)
        cypher.push(choice)
        _ = valid_pool.delete(choice)
        sleep(1)
      end
    end
    @cypher = cypher
    cypher
  end

  private

  def validate_choice(pool)
    choice = ""
    until pool.include?(choice)
      write(
        "Please choose a segment to add from #{pool.join(", ")}.\n",
        @default_delay,
      )
      write(
        "(If you have allowed blank spaces in the code, you can hit SPACEBAR to add one)\n",
        @default_delay,
      )
      write(
        "Only enter one number (or space) at a time, then hit Enter.\n",
        @default_delay,
      )
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
