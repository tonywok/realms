require "spec_helper"

RSpec.describe Realms::Cards::Junkyard do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 5
  include_examples "factions", :machine_cult
  include_examples "cost", 6

  describe "#primary_ability" do
    let(:another_card) { Realms::Cards::Scout.new(game.p1, index: 42) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.discard_pile << another_card
      game.start
      game.decide(:play, card.key)
      game.decide(:primary, card.key)
    end

    include_examples "scrap_card_from_hand_or_discard_pile"
  end
end
