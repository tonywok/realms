require "realms/actions/registry"

module Realms
  module Actions
    def self.registry
      @registry ||= Registry.configure do
        action(:acquire) do |card|
          turn.trade -= card.cost
          active_player.acquire(card)
        end

        action(:ally_ability) do |card|
          perform(card.ally_ability(turn))
        end

        action(:attack) do |target|
          case target
          when Realms::Player
            turn.passive_player.authority -= turn.combat
            turn.combat = 0
          else
            turn.combat -= target.defense
            passive_player.destroy(target)
          end
        end

        action(:discard) do |card|
          choose(active_player.hand.cards) do |chosen_card|
            active_player.discard(chosen_card)
          end
        end

        action(:end_turn)

        action(:play) do |card|
          active_player.play(card)
          perform card.primary_ability(turn) if card.automatic_primary_ability?
          active_player.in_play.actions.select(&:auto?).each do |action|
            perform action
          end
        end

        action(:primary_ability) do |card|
          perform card.primary_ability(turn)
          active_player.in_play.actions.select(&:auto?).each do |action|
            perform action
          end
        end

        action(:scrap_ability) do |card|
          active_player.scrap(card)
          perform card.scrap_ability(turn)
          # TODO: put explorers back
        end
      end
    end
  end
end
