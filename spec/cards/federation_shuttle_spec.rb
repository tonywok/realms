require "spec_helper"

RSpec.describe Realms::Cards::FederationShuttle do
  include_examples "factions", :trade_federation
  include_examples "cost", 1

  describe "#primary_ability" do
    include_context "primary_ability"

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(2)
    }
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::Cutter

    it {
      expect {
        game.play(card)
      }.to change { game.active_player.authority }.by(4)
    }
  end
end
