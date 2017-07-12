require "spec_helper"

RSpec.describe Realms::Cards::Dreadnaught do
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 7

  describe "#primary_ability" do
    include_context "primary_ability"

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(7).and \
           change { game.active_player.draw_pile.length }.by(-1)
    }
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"
    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(5) }
  end
end
