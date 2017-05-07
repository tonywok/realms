require "spec_helper"

RSpec.describe Realms::Cards::Junkyard do
  include_examples "type", :outpost
  include_examples "defense", 5
  include_examples "factions", :machine_cult
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "scrap_ability"

    include_examples "scrap_card_from_hand_or_discard_pile" do
      before do
        game.base_ability(card)
      end
    end
  end
end
