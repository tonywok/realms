require "spec_helper"

RSpec.describe Realms::Cards::BlobCarrier do
  include_examples "factions", :blob
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "primary_ability"
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(7) }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BlobWheel do
      let(:selected_card) { Realms::Cards::BlobDestroyer.new(game.trade_deck, index: 10) }
      before do
        game.trade_deck.trade_row.cards[0] = selected_card
      end
    end

    it "acquire any ship without paying its cost and put it on top of your deck" do
      game.ally_ability(card)
      game.decide(:acquire_ship_and_top_deck, selected_card)
      expect(game.trade_deck.trade_row).to_not include(selected_card)
      expect(game.trade_deck.trade_row.length).to eq(5)
      expect(game.active_player.draw_pile.first).to eq(selected_card)
      game.active_player.draw(1)
      expect(game.active_player.hand).to include(selected_card)
    end
  end
end
