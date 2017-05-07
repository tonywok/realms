require "spec_helper"

RSpec.describe Realms::Cards::Explorer do
  include_examples "factions", :unaligned
  include_examples "cost", 2

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(2)
    }
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"
    it {
      expect {
        game.scrap_ability(card)
      }.to change { game.active_turn.combat }.by(2)
    }
  end
end
