require "spec_helper"

RSpec.describe Realms::Cards::BarterWorld do
  include_examples "type", :base
  include_examples "defense", 4
  include_examples "factions", :trade_federation
  include_examples "cost", 4

  describe "#primary_ability" do
    include_examples "base_ability" do
      before { game.base_ability(card) }
    end

    context "authority" do
      it { expect { game.decide(:"barter_world.authority") }.to change { game.active_player.authority }.by(2) }
    end

    context "trade" do
      it { expect { game.decide(:"barter_world.trade") }.to change { game.active_turn.trade }.by(2) }
    end
  end

  describe "#scrap_ability" do
    include_examples "scrap_ability"

    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(5) }
  end
end
