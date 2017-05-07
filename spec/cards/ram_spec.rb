require "spec_helper"

RSpec.describe Realms::Cards::Ram do
  include_examples "factions", :blob
  include_examples "cost", 3

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(5)
    }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BlobFighter
    it {
      expect {
        game.ally_ability(card)
      }.to change { game.active_turn.combat }.by(2)
    }
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"
    it {
      expect {
        game.scrap_ability(card)
      }.to change { game.active_turn.trade }.by(3)
    }
  end
end
