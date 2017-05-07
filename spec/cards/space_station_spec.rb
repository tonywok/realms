require "spec_helper"

RSpec.describe Realms::Cards::SpaceStation do
  include_examples "type", :outpost
  include_examples "defense", 4
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 4

  describe "#primary_ability" do
    include_context "base_ability"
    it { expect { game.base_ability(card) }.to change { game.active_turn.combat }.by(2) }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::SurveyShip
    it { expect { game.ally_ability(card) }.to change { game.active_turn.combat }.by(2) }
  end

  describe "#scrap_ability" do
    include_context "base_ability"
    it { expect { game.scrap_ability(card) }.to change { game.active_turn.trade }.by(4) }
  end
end
