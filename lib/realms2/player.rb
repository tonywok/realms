require "realms2/deck"

module Realms2
  class Player
    attr_reader :name, :deck

    def initialize(name)
      @name = name
      @deck = Deck.new
    end

    def to_s
      @name
    end
  end
end
