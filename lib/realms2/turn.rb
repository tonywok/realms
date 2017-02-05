require "realms2/phases"

module Realms2
  class Turn < Yielder
    @id = 0

    def self.next_id
      @id+=1
    end

    attr_reader :id,
                :trade,
                :combat,
                :game,
                :active_player,
                :passive_player

    def initialize(game, active_player, passive_player)
      @id = self.class.next_id
      @game = game
      @active_player = active_player
      @passive_player = passive_player
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
