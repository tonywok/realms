require "spec_helper"

RSpec.describe Realms::Cards::DefenseCenter do
  include_examples "type", :outpost
  include_examples "defense", 5
  include_examples "factions", :trade_federation
  include_examples "cost", 5

  describe "#primary_ability" do
    include_context "base_ability" do
      before do
        game.base_ability(card)
      end
    end

    context "authority" do
      it { expect { game.decide(:defense_center, :authority) }.to change { game.active_player.authority }.by(3) }
    end

    context "combat" do
      it { expect { game.decide(:defense_center, :combat) }.to change { game.active_turn.combat }.by(2) }
    end
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::FederationShuttle
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(2) }
  end
end

