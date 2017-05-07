require "spec_helper"

RSpec.describe Realms::Cards::Corvette do
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 2

  describe "#primary_ability" do
    include_context "primary_ability"

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(1).and \
           change { game.p1.deck.draw_pile.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::ImperialFighter
    it { expect { game.ally_ability(card) }.to change { game.active_turn.combat }.by(2) }
  end
end
