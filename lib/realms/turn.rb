require "realms/phases"

module Realms
  class Turn < Yielder
    attr_reader :id,
                :active_player,
                :passive_player,
                :trade_deck

    attr_accessor :trade,
                  :combat

    def self.first(game)
      active_player, passive_player = game.players.shuffle(random: game.rng)
      new(
        id: 0,
        active_player: active_player,
        passive_player: passive_player,
        trade_deck: game.trade_deck,
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

    def execute
      perform Phases::Upkeep.new(self)
      perform Phases::Main.new(self)
      perform Phases::Discard.new(self)
      perform Phases::Draw.new(self)
    end
  end
end
