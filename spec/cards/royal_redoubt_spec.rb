require "spec_helper"

RSpec.describe Realms::Cards::RoyalRedoubt do
  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "primary_ability"
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(3) }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::SurveyShip
    it {
      game.ally_ability(card)
      game.end_turn
      expect {
        game.decide(game.active_player.hand.sample)
      }.to change { game.active_player.hand.length }.by(-1)
    }
  end
end
