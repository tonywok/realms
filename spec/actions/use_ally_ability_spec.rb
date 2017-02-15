require "spec_helper"

RSpec.describe Realms2::Actions::UseAllyAbility do
  let(:game) { Realms2::Game.new }
  let(:card1) { Realms2::Cards::BlobFighter.new(game.p1) }
  let(:card2) { Realms2::Cards::BlobFighter.new(game.p1) }

  before do
    game.p1.deck.hand << card1
    game.p1.deck.hand << card2
    game.start
  end

  it do
    game.decide(:hand, :blob_fighter)
    expect(game.current_choice.options[:ally]).to_not have_key(:blob_fighter)
    game.decide(:hand, :blob_fighter)
    expect(game.current_choice.options[:ally]).to_not have_key(:blob_fighter)
    expect(game.current_choice.options[:ally]).to_not have_key(:blob_fighter)
    expect {
      game.decide(:ally, :blob_fighter)
    }.to change { game.p1.deck.hand.length }.by(1)
    expect {
      game.decide(:ally, :blob_fighter)
    }.to change { game.p1.deck.hand.length }.by(1)
  end
end
