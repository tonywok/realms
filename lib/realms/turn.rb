require "realms/choice"
require "realms/phases"
require "realms/event_manager"

module Realms
  class Turn < Yielder
    @id = 0

    def self.next_id
      @id+=1
    end

    attr_reader :id,
                :active_player,
                :passive_player,
                :trade_deck,
                :event_manager
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
      @event_manager = EventManager.new
      @activated_ally_ability = []
      @activated_base_ability = []
    end

    def execute
      perform Phases::Main.new(self)
      perform Phases::Discard.new(self)
      perform Phases::Draw.new(self)
    end
  end
end
