require "realms2/phases"

module Realms2
  class Turn < Yielder
    @id = 0

    def self.next_id
      @id+=1
    end

    attr_reader :id,
                :active_player,
                :passive_player,
                :trade_deck
    attr_accessor :trade,
                  :combat

    def initialize(active_player, passive_player, trade_deck)
      @id = self.class.next_id
      @active_player = active_player
      @passive_player = passive_player
      @trade_deck = trade_deck
      @trade = 0
      @combat = 0
    end

    def execute
      puts "[#{id}]: starting #{active_player}'s main phase"
      perform Phases::Main.new(self)
      puts "[#{id}]: ending #{active_player}'s main phase"
      puts "[#{id}]: starting #{active_player}'s discard phase"
      perform Phases::Discard.new(self)
      puts "[#{id}]: ending #{active_player}'s discard phase"
      puts "[#{id}]: starting #{active_player}'s draw phase"
      perform Phases::Draw.new(self)
      puts "[#{id}]: ending #{active_player}'s draw phase"
      puts "\n"
    end
  end
end
