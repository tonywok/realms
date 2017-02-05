module Realms2
  class Card
    attr_reader :name, :cost

    def initialize(name:, cost:)
      @name = name
      @cost = cost
    end
  end

  class Deck
    def initialize
      scouts = 7.times.map { Card.new(name: "Scout", cost: 0) }
      vipers = 3.times.map { Card.new(name: "Viper", cost: 0) }
      @draw = scouts + vipers
      @hand = []
      @discard_pile = []
      @battlefield = []
    end
  end
end
