require "spec_helper"

RSpec.describe Realms::Cards::PatrolMech do
  include_examples "factions", :machine_cult
  include_examples "cost", 4

  describe "#primary_ability" do
    include_context "primary_ability" do
      before { game.play(card) }
    end

    context "trade" do
      it { expect { game.decide(:trade) }.to change { game.active_turn.trade }.by(3) }
    end

    context "combat" do
      it { expect { game.decide(:combat) }.to change { game.active_turn.combat }.by(5) }
    end
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BattleStation

    include_examples "scrap_card_from_hand_or_discard_pile" do
      before do
        game.decide(:trade)
        game.ally_ability(card)
      end
    end
  end
end
