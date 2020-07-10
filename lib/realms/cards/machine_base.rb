module Realms
  module Cards
    class MachineBase < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 7

      primary do
        # effect(:draw_then_scrap_from_hand) do
        #   active_player.draw(1)
        #   choose(active_player.hand)do |chosen_card|
        #     active_player.scrap(chosen_card)
        #   end
        # end
      end
    end
  end
end
