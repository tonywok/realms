require "spec_helper"

RSpec.describe Realms::CardPools::Vanilla do
  let(:game) { Realms::Game.new }
  let(:trade_deck) { game.trade_deck }
  let(:set) { described_class.new(trade_deck) }

  it "has cards" do
    expect(set.cards).to_not be_empty
    expect(set.cards.map(&:key)).to include(*[
      :blob_fighter_0,
      :blob_fighter_1,
      :blob_fighter_2,
    ])
    expect(trade_deck.trade_row.cards).to_not be_empty
  end
end
