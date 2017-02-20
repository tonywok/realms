# require "realms/sets/card_set"
#
# Realms::Sets::CardSet.set :vanilla do
#   ship "cutter" do
#     faction :trade_federation
#     cost 2
#     primary_ability do
#       trade 2
#       authority 4
#     end
#     ally_ability do
#       attack 4
#     end
#   end

  # ship "blob_fighter" do
  #   faction :blob
  #   cost 1
  #   primary_ability do
  #     attack 3
  #   end
  #   ally_ability do
  #     draw
  #   end
  # end
  #
  # ship "battle_pod" do
  #   faction :blob
  #   cost 2
  #   primary_ability do
  #     attack 4
  #     optional do
  #       attack 1
  #     end
  #   end
  # end

  # ship "trade_pod" do
  #   faction :blob
  #   cost 2
  #   primary_ability do
  #     trade 3
  #   end
  #   ally_ability do
  #     attack 2
  #   end
  # end
  #
  # base "blob_wheel" do
  #   faction :blob
  #   cost 3
  #   defense 5
  #   primary_ability do
  #     attack 1
  #   end
  #   scrap_ability do
  #     trade 3
  #   end
  # end
  #
  # ship "ram" do
  #   faction :blob
  #   cost 3
  #   primary_ability do
  #     attack 5
  #   end
  #   ally_ability do
  #     attack 2
  #   end
  #   scrap_ability do
  #     trade 3
  #   end
  # end
  #
  # ship "blob_destroyer" do
  #   faction :blob
  #   cost 4
  #   primary_ability do
  #     attack 6
  #   end
  #   ally_ability do
  #     and_or do
  #       destroy_base
  #       scrap_trade_row
  #     end
  #   end
  # end
  #
  # base "the_hive" do
  #   defense 5
  #   faction :blob
  #   cost 5
  #   primary_ability do
  #     attack 3
  #   end
  #   ally_ability do
  #     draw
  #   end
  # end
  #
  # ship "battle_blob" do
  #   faction :blob
  #   cost 6
  #   primary_ability do
  #     attack 8
  #   end
  #   ally_ability do
  #     draw
  #   end
  #   scrap_ability do
  #     attack 4
  #   end
  # end
  #
  # ship "blob_carrier" do
  #   faction :blob
  #   cost 6
  #   primary_ability do
  #     attack 7
  #   end
  #   ally_ability do
  #     acquire_top_deck
  #   end
  # end
  #
  # ship "mothership" do
  #   faction :blob
  #   cost 7
  #   primary_ability do
  #     all do
  #       attack 6
  #       draw
  #     end
  #   end
  #   ally_ability do
  #     draw
  #   end
  # end
  #
  # base "blob_world", cost: 8, defense: 7, faction: :blob do
  #   primary_ability do
  #     choose do
  #       attack 5
  #       draw_for_each_faction :blob
  #     end
  #   end
  # end
# end
