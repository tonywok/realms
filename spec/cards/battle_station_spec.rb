require "spec_helper"

RSpec.describe Realms::Cards::BattleStation do
  include_examples "type", :outpost
  include_examples "defense", 5
  include_examples "factions", :machine_cult
  include_examples "cost", 3

  describe "#scrap_ability" do
    include_context "scrap_ability"
    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(5) }
  end
end
