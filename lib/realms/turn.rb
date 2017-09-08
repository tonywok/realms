module Realms
  class Turn
    attr_reader :id,
                :active_player,
                :passive_player,
                :trade_deck

    attr_accessor :trade,
                  :combat

    def self.first(trade_deck, active_player, passive_player)
      new(
        id: 0,
        active_player: active_player,
        passive_player: passive_player,
        trade_deck: trade_deck,
      )
    end

    def initialize(id:, active_player:, passive_player:, trade_deck:)
      @id = id
      @active_player = active_player
      @passive_player = passive_player
      @trade_deck = trade_deck
      @trade = 0
      @combat = 0
    end

    def next
      self.class.new(
        id: id + 1,
        active_player: passive_player,
        passive_player: active_player,
        trade_deck: trade_deck,
      )
    end
  end
end
