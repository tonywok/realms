require "spec_helper"

RSpec.describe Realms::Cards::Cutter do
  include_examples "factions", :trade_federation
  include_examples "cost", 2

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(2).and \
           change { game.p1.authority }.by(4)
    }
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::FederationShuttle
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(4) }
  end
end
