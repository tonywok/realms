require "spec_helper"

RSpec.describe Realms::Cards::TradePod do
  include_examples "factions", :blob
  include_examples "cost", 2

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(3)
    }
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::BlobFighter
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(2)
    }
  end
end
