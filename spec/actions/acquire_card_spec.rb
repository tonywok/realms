require "spec_helper"

RSpec.describe Realms::Actions::AcquireCard do
  let(:game) { Realms::Game.new }

  context "acquiring cards from the trade row" do
    let(:card) { Realms::Cards::Scout.new(game.p1, index: 10) }
    let(:trade_row_card) { Realms::Cards::BlobFighter.new(game.trade_deck) }

    before do
      game.p1.deck.hand << card
      game.trade_deck.trade_row.cards[0] = trade_row_card
      game.start
    end

    it "acquires a card from the trade row paid for in trade" do
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(1)

      expect {
        game.acquire(trade_row_card)
        expect(trade_row_card.owner).to eq(game.p1)
      }.to change { game.p1.deck.discard_pile.length }.by(1).and \
           change { game.trade_deck.trade_row.length }.by(0)

      expect(game.active_turn.trade).to eq(0)
    end
  end

  context "when the turn doesn't have enough trade" do
    let(:trade_row_card) { Realms::Cards::BlobWheel.new(game.trade_deck) }
    let(:cards_in_hand) do
      [
        Realms::Cards::Scout.new(game.p1, index: 10),
        Realms::Cards::Scout.new(game.p1, index: 11),
        Realms::Cards::Viper.new(game.p1, index: 10),
      ]
    end

    before do
      cards_in_hand.each { |card| game.p1.deck.hand << card }
      game.trade_deck.trade_row.cards[0] = trade_row_card
      game.start
    end

    it "only sees explorer as an option" do
      expect {
        cards_in_hand.each { |card| game.play(card) }
      }.to change { game.active_turn.trade }.by(2).and \
           change { game.active_turn.combat }.by(1)

      expect(game.current_choice.options).to have_key(:"acquire.explorer_0")
      expect(game.current_choice.options.keys).to_not include(:"acquire.#{trade_row_card.key}")
    end
  end
end
