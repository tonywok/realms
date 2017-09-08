require "spec_helper"

RSpec.describe Realms::Cards::Flagship do
  include_examples "factions", :trade_federation
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "primary_ability"

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(5).and \
           change { game.active_player.draw_pile.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::FederationShuttle
    it { expect { game.play(card) }.to change { game.active_player.authority }.by(9) }
  end
end
