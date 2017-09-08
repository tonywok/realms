require "spec_helper"

RSpec.describe Realms::Zones::Explorers do
  let(:game) { Realms::Game.new }
  let(:explorers) do
    100.times.map { |i| game.p1.scout }
  end

  before do
    explorers.each do |card|
      game.p1.hand << card
    end
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
