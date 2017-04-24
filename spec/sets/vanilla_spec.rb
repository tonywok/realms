require "spec_helper"

RSpec.describe Realms::Sets::Vanilla do
  let(:set) { described_class.new }

  it "has cards" do
    expect(set.cards).to_not be_empty
    expect(set.cards.map(&:key)).to include(*[
      :blob_fighter_0,
      :blob_fighter_1,
      :blob_fighter_2,
    ])
    expect(Realms::Game.new.start.trade_deck.trade_row.cards).to_not be_empty
  end
end
