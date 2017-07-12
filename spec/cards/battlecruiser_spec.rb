require "spec_helper"

RSpec.describe Realms::Cards::Battlecruiser do
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(5).and \
           change { game.active_player.draw_pile.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::ImperialFighter
    it {
      game.ally_ability(card)
      game.end_turn
      expect {
        game.decide(game.active_player.hand.sample.key)
      }.to change { game.active_player.hand.length }.by(-1)
    }
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"

    include_examples "destroy_target_base" do
      before do
        expect { game.scrap_ability(card) }.to change { game.active_player.draw_pile.length }.by(-1)
      end
    end
  end
end
