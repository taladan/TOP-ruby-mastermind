# lib/mastermind.rb
#
# Mastermind class handles the functionality of configuring
# the game for play

require "./lib/cypher"
require "./lib/player"
require "./lib/computer"
require "./lib/prompt"

class Mastermind
  attr_reader :player, :code
  def initialize
    @ask = Prompt.new()
    configure_gameplay()
  end

  private

  def configure_gameplay()
    player_name = @ask.query("intro")
    @player = Player.new(@player_name)

    @player.config[:allow_duplicates] = @ask.query("duplicates")
    @player.config[:blanks] = @ask.query("blanks")
    @player.config[:total_attempts] = @ask.query("attempts")
    @player.config[:cypher_length] = @ask.query("length")
    @player.config[:role] = @ask.query("role")

    # generate code & set
    @code =
      Cypher.new(
        @player.config[:allow_duplicates],
        @player.config[:allow_blanks],
        @player.config[:cypher_length],
      )
    @player.config[:cypher] = get_code(@player.config[:role])
  end

  def get_code(role)
    # options[:turns]
    if role == "breaker"
      @code.breaker_generate
    else
      @code.maker_generate
    end
    @code.cypher
  end
end
