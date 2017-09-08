require "spec_helper"

RSpec.describe Realms::CardPools::Vanilla do
  let(:game) { Realms::Game.new }
  let(:trade_deck) { game.trade_deck }

  it "has cards" do
    expect(trade_deck.draw_pile.cards).to_not be_empty
    expect(trade_deck.draw_pile.cards.map(&:key)).to include(*[
      :blob_fighter_0,
      :blob_fighter_1,
      :blob_fighter_2,
    ])
  end
end
