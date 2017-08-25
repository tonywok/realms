require "spec_helper"

RSpec.describe Realms::Cards::TradeBot do
  include_examples "factions", :machine_cult
  include_examples "cost", 1

  describe "#primary_ability" do
    include_context "primary_ability"

    include_examples "scrap_card_from_hand_or_discard_pile" do
      before do
        expect {
          game.play(card)
        }.to change { game.active_turn.trade }.by(1)
      end
    end
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::BattleStation

    it {
      expect {
        game.play(card)
        game.decide(:scrap_from_hand_or_discard_pile, :none)
      }.to change { game.active_turn.combat }.by(2)
    }
  end
end
