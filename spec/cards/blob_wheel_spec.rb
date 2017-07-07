require "spec_helper"

RSpec.describe Realms::Cards::BlobWheel do
  include_examples "type", :base
  include_examples "defense", 5
  include_examples "factions", :blob
  include_examples "cost", 3

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(1)
    }
  end

  describe "#scrap" do
    include_context "scrap_ability"
    it {
      expect {
        game.scrap_ability(card)
      }.to change { game.active_turn.trade }.by(3)
    }
  end
end
