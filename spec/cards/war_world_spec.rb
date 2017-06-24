require "spec_helper"

RSpec.describe Realms::Cards::WarWorld do
  include_examples "type", :outpost
  include_examples "defense", 4
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 5

  describe "#primary_ability" do
    include_context "base_ability"
    it { expect { game.base_ability(card) }.to change { game.active_turn.combat }.by(3) }
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::SurveyShip
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(4) }
  end
end
