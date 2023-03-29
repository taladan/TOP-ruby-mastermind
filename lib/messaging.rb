# lib/messaging.rb
#
# Handle writing messages to the terminal
#
require_relative "logo"

module Messaging
  def write(message, delay = 0.05)
    message.each_char do |c|
      putc c
      sleep delay
    end
  end

  def self.clear_screen()
    include Logo
    system("clear") || system("cls")
    Logo.put_logo()
  end
end
