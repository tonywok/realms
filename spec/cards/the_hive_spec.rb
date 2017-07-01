require "spec_helper"

RSpec.describe Realms::Cards::TheHive do
  include_examples "type", :base
  include_examples "defense", 5
  include_examples "factions", :blob
  include_examples "cost", 5

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(3)
    }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BlobWheel
    it {
      expect {
        game.ally_ability(card)
      }.to change { game.p1.draw_pile.length }.by(-1)
    }
  end
end
