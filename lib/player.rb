# lib/player.rb

class Player
  attr_accessor :name, :config
  def initialize(name)
    @name = name
    @config = {}
  end
end
