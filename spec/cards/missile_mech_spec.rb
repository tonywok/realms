require "spec_helper"

RSpec.describe Realms::Cards::MissileMech do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :machine_cult
  include_examples "cost", 6

  describe "#primary_ability" do
    it_behaves_like "destroy_target_base" do
      before do
        setup(game)
        game.start
        expect { game.decide(:play, card.key) }.to change { game.active_turn.combat }.by(6)
      end
    end
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BattleStation.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.decide(:play, ally_card.key)
      game.decide(:play, card.key)
      game.decide(:none)
    end

    it { expect { game.decide(:ally, card.key) }.to change { game.p1.deck.hand.length }.by(1) }
  end
end
