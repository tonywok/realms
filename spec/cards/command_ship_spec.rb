require "spec_helper"

RSpec.describe Realms::Cards::CommandShip do
  include_examples "factions", :trade_federation
  include_examples "cost", 8

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_player.authority }.by(4).and \
           change { game.active_turn.combat }.by(5).and \
           change { game.active_player.draw_pile.length }.by(-2)
    }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::FederationShuttle

    include_examples "destroy_target_base" do
      before do
        game.ally_ability(card)
      end
    end
  end
end
