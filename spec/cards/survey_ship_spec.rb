require "spec_helper"

RSpec.describe Realms::Cards::SurveyShip do
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 3

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(1).and \
           change { game.p1.deck.draw_pile.length }.by(-1)
    }
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"
    it {
      expect {
        game.scrap_ability(card)
        game.end_turn
        game.decide(game.p2.hand.sample.key)
      }.to change { game.p2.hand.length }.by(-1)
    }
  end
end
