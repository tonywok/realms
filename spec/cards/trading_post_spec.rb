require "spec_helper"

RSpec.describe Realms::Cards::TradingPost do
  include_examples "type", :outpost
  include_examples "defense", 4
  include_examples "factions", :trade_federation
  include_examples "cost", 3

  describe "#primary_ability" do
    include_context "base_ability" do
      before do
        game.base_ability(card)
      end
    end

    context "authority" do
      it { expect { game.decide(:trading_post, :authority) }.to change { game.active_player.authority }.by(1) }
    end

    context "trade" do
      it { expect { game.decide(:trading_post, :trade) }.to change { game.active_turn.trade }.by(1) }
    end
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"
    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(3) }
  end
end
