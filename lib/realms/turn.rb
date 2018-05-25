module Realms
  class Turn
    attr_reader :game,
                :id,
                :active_player,
                :passive_player

    attr_accessor :combat, :trade

    delegate :trade_deck,
             :publish,
             to: :game

    def self.first(game)
      new(game, 0, active_player: game.p1, passive_player: game.p2)
    end

    def initialize(game, id, active_player:, passive_player:)
      @game = game
      @id = id
      @trade = 0
      @combat = 0
      @active_player = active_player
      @passive_player = passive_player
    end

    def next
      self.class.new(game, id + 1, active_player: passive_player, passive_player: active_player)
    end
  end
end
