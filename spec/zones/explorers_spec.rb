require "spec_helper"

RSpec.describe Realms::Actions::AcquireCard do
  let(:game) { Realms::Game.new }
  let(:hand) do
    Realms::Zones::Hand.new(game.p1, 100.times.map { |i| Realms::Cards::Scout.new(game.p1, index: 10 + i) })
  end

  before do
    game.p1.deck.hand = hand
    game.start
  end

  it "is an infinite list of explorers" do
    game.p1.hand.each do |card|
      game.play(card)
    end
    expect(game.active_turn.trade).to be >= 50
    25.times do |i|
      game.acquire(:"explorer_#{i}")
    end
    expect(game.p1.discard_pile.length).to eq(25)
  end
end
