# lib/player.rb

class Player
  attr_accessor :name, :config
  def initialize(name)
    @name = name
    @config = {}
    # @guess[:1] = ["4635", "●○"]
    @guesses = {}
  end
end
