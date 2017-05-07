require "spec_helper"

RSpec.describe Realms::Cards::TradeEscort do
  include_examples "factions", :trade_federation
  include_examples "cost", 5

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(4).and \
           change { game.p1.authority }.by(4)
    }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::FederationShuttle

    it { expect { game.ally_ability(card) }.to change { game.p1.deck.hand.length }.by(1) }
  end
end
