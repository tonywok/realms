require "realms2/choice"
require "realms2/actions"

module Realms2
  class PlayerAction < Choice

    attr_reader :turn

    def initialize(turn)
      @turn = turn
      @options = {
        play_card: Actions::PlayCard.new(turn),
        primary_ability: Actions::PrimaryAbility.new(turn),
        ally_ability: Actions::AllyAbility.new(turn),
        scrap_ability: Actions::ScrapAbility.new(turn),
        use_trade: Actions::UseTrade.new(turn),
        use_combat: Actions::UseCombat.new(turn),
        end_turn: Actions::EndTurn.new(turn),
      }
    end
  end
end
