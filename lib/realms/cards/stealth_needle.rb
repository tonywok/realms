module Realms
  module Cards
    class StealthNeedle < Card
      faction :machine_cult
      cost 4

      primary do
      #   effect(:copy_ship) do
      #     # move this into "in play" zone? Introduce some sort of query concept?
      #     ships = active_player.in_play.select(&:ship?).index_by(&:key).except(card.key).values

      #     choose(ships) do |ship|
      #       card.definition = ship.definition.clone.tap do |definition|
      #         card.factions.each { |faction| definition.factions << faction }
      #       end
      #       perform Actions::PrimaryAbility.new(turn, card)
      #     end
      #   end
      end
    end
  end
end
