require "spec_helper"

RSpec.describe Realms::Cards::PortOfCall do
  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", :trade_federation
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "primary_ability"

    it { expect { game.play(card) }.to change { game.active_turn.trade }.by(3) }
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"

    include_examples "destroy_target_base" do
      before do
        expect {
          game.scrap_ability(card)
        }.to change { game.active_player.deck.hand.length }.by(1)
      end
    end
  end
end
