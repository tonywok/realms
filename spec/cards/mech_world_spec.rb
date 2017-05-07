require "spec_helper"

RSpec.describe Realms::Cards::MechWorld do
  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", :machine_cult
  include_examples "cost", 5

  describe "#static_ability" do
    include_context "ally_ability", Realms::Cards::Cutter

    it "counts as an ally ability for all factions" do
      expect { game.ally_ability(ally) }.to change { game.active_turn.combat }.by(4)
    end
  end
end
