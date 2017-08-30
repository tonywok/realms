require "spec_helper"

RSpec.describe Realms::Cards::MissileMech do
  include_examples "factions", :machine_cult
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "primary_ability"
    it_behaves_like "destroy_target_base" do
      before do
        expect { game.play(card) }.to change { game.active_turn.combat }.by(6)
      end
    end
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BattleStation

    it {
      game.decide(:destroy_target_base, :none)
      expect {
        game.ally_ability(card)
      }.to change { game.active_player.hand.length }.by(1)
    }
  end
end
