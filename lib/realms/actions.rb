require "realms/actions/action"

Dir[File.expand_path('../actions/*.rb', __FILE__)].each do |file|
  require file
end

module Realms
  module Actions
    def self.actions
      @actions ||= Registry.configure do
        action(:play) do
          targets { active_player.hand }
          execution { |card| active_player.play(card) }
        end

        action(:attack) do
          targets do
            eligible = ->(base) { active_player.combat >= base.defense }
            passive_players.each_with_object([]) do |passive_player, targets|
              outposts, bases = passive_player.in_play.select(&:base?).partition(&:outpost?)
              if outposts.any?
                targets.concat(outposts.select(&eligible))
              else
                targets.concat(bases.select(&eligible))
                targets << passive_player if active_player.combat.positive?
              end
            end
          end
          execution do |target|
            if passive_players.include?(target)
              target.authority -= active_player.combat.value
              active_player.combat = 0
            else
              active_player.combat -= target.defense
              target.owner.destroy(target)
            end
          end
        end

        action(:acquire) do
          targets do
            layout.trade_row.select do |card|
              card.cost <= active_player.trade.value
            end
          end
          execution do |card|
            active_player.trade -= card.cost
            active_player.acquire(card)
          end
        end

        action(:primary_ability) do
          targets do
            active_player.in_play.each_with_object([]) do |card, abilities|
              abilities << card.primary_ability if card.primary_ability.eligible?
            end
          end
          execution { |ability| perform(ability) }
        end

        action(:scrap_ability) do
          targets do
            active_player.in_play.each_with_object([]) do |card, abilities|
              abilities << card.scrap_ability if card.scrap_ability.eligible?
            end
          end
          execution do |ability|
            active_player.scrap(ability.card)
            perform(ability)
          end
        end

        action(:ally_ability) do
          targets do
            active_player.in_play.each_with_object([]) do |card, abilities|
              abilities << card.ally_ability if card.ally_ability.eligible?
            end
          end
          execution { |ability| perform(ability) }
        end

        action(:end_turn)
      end
    end
  end
end