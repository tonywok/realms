require "spec_helper"

RSpec.describe Realms::Cards::MachineBase do
  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", :machine_cult
  include_examples "cost", 7

  describe "#primary_ability" do
    include_context "base_ability"

    it "draws a card and scraps a card from hand" do
      expect {
        game.base_ability(card)
      }.to change { game.active_player.deck.draw_pile.length }.by(-1)

      card_in_hand = game.active_player.deck.hand.sample

      expect {
        game.decide(:draw_then_scrap_from_hand, card_in_hand)
      }.to change { game.trade_deck.scrap_heap.length }.by(1)
    end
  end
end
