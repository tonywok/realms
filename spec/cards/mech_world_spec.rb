require "spec_helper"

RSpec.describe Realms::Cards::MechWorld do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", :machine_cult
  include_examples "cost", 5

  describe "#static_ability" do
    let(:non_ally_card) { Realms::Cards::Cutter.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << non_ally_card
      game.start
    end

    it "counts as an ally ability for all factions" do
      game.play(non_ally_card)
      game.play(card)
      expect { game.ally_ability(non_ally_card) }.to change { game.active_turn.combat }.by(4)
    end
  end
end
