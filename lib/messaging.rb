# lib/messaging.rb
#
# Handle writing messages to the terminal
#

module Messaging
  def write(message, delay = 0.05)
    message.each_char do |c|
      putc c
      sleep delay
    end
  end

  def self.clear_screen()
    system("clear") || system("cls")
  end
end
