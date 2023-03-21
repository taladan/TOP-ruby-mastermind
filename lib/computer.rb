# lib/computer.rb
require_relative "player"

class Computer < Player
  attr_accessor :guess_pool

  def initialize
    super(@guesses)
    @guess_pool = load_pools()
  end

  def guess(config, code)
    # pool = generate_pool(config[:cypher_length], config[:allow_duplicates], config[:allow_blanks])
    master_mind(
      config[:cypher_length],
      config[:allow_duplicates],
      config[:allow_blanks],
    )
  end

  def load_pools()
    pools = {
      cart_2: Marshal.load(File.read("cart_2.dump")),
      cart_3: Marshal.load(File.read("cart_3.dump")),
      cart_4: Marshal.load(File.read("cart_4.dump")),
      cart_5: Marshal.load(File.read("cart_5.dump")),
      cart_6: Marshal.load(File.read("cart_6.dump")),
    }
    pools
  end
end
