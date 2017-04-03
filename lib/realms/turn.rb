require "realms/choice"
require "realms/phases"

module Realms
  class Turn < Yielder
    include Wisper::Publisher

    @id = 0

    def self.next_id
      @id+=1
    end

    attr_reader :id,
                :active_player,
                :passive_player,
                :trade_deck
    attr_accessor :trade,
                  :combat,
                  :activated_ally_ability,
                  :activated_base_ability

    def initialize(active_player, passive_player, trade_deck)
      @id = self.class.next_id
      @active_player = active_player
      @passive_player = passive_player
      @trade_deck = trade_deck
      @trade = 0
      @combat = 0
      @activated_ally_ability = []
      @activated_base_ability = []
    end

    def execute
      perform Phases::Upkeep.new(self)
      perform Phases::Main.new(self)
      perform Phases::Discard.new(self)
      perform Phases::Draw.new(self)
      broadcast(:turn_end)
    end
  end
end
