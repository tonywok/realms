require "spec_helper"

RSpec.describe Realms::Cards::BlobDestroyer do
  include_examples "factions", :blob
  include_examples "cost", 4

  describe "#primary_ability" do
    include_context "primary_ability"
    it { expect { game.play(card) }.to change { game.active_turn.combat }.to eq(6) }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BlobWheel

    it "you may destroy target base and/or and scrap a card in the trade row" do
      game.ally_ability(card)
      game.decide(:destroy_target_base, ally)
      expect(game.active_player.in_play).to_not include(ally)
      expect(game.active_player.discard_pile).to include(ally)
      trade_row_card = game.trade_deck.trade_row.sample
      game.decide(:scrap_card_from_trade_row, trade_row_card)
      expect(game.trade_deck.scrap_heap).to include(trade_row_card)
    end
  end
end
