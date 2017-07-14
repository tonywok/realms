require "spec_helper"

RSpec.describe Realms::Zones::Explorers do
  let(:game) { Realms::Game.new }
  let(:hand) do
    Realms::Zones::Hand.new(game.active_player, 100.times.map { |i| game.active_player.scout })
  end

  before do
    game.active_player.deck.hand = hand
    game.start
  end

  it "is an infinite list of explorers" do
    game.active_player.hand.each do |card|
      game.play(card)
    end
    expect(game.active_turn.trade).to be >= 50
    25.times do |i|
      game.acquire(:"explorer_#{i}")
    end
    expect(game.active_player.discard_pile.length).to eq(25)
  end
end
