require "realms2/choice"
require "realms2/actions"
require "realms2/abilities"
require "realms2/cards"

module Realms2
  class PlayerAction < Choice
    attr_reader :turn

    def initialize(turn)
      @turn = turn
      @options = {}
      @options[:hand] = play_card_from_hand
      @options[:primary] = primary_abilities
      @options[:ally] = ally_abilities
      @options[:scrap] = scrap_abilities
      @options[:acquire] = trade_row
      @options[:end_turn] = end_turn
      @options[:use_combat] = use_combat
    end

    def play_card_from_hand
      turn.active_player.deck.hand.each_with_object({}) do |card, opts|
        opts[card.key] = Actions::PlayCard.new(card)
      end
    end

    # TODO bases
    def primary_abilities
      {}
    end

    def ally_abilities
      turn.active_player.deck.battlefield.each_with_object({}) do |card, opts|
        opts[card.key] = Actions::UseAllyAbility.new(card)
      end
    end

    def scrap_abilities
      turn.active_player.deck.battlefield.each_with_object({}) do |card, opts|
        opts[card.key] = Actions::UseScrapAbility.new(card)
      end
    end

    def trade_row
      { explorer: Actions::AcquireExplorer.new(turn) }
    end

    def use_combat
      Actions::UseCombat.new(turn)
    end

    def end_turn
      Actions::EndMainPhase.new(turn)
    end
  end
end
