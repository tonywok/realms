require "spec_helper"

RSpec.describe Realms::Cards::PatrolMech do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :machine_cult
  include_examples "cost", 4

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
    end

    context "trade" do
      it { expect { game.decide(:trade) }.to change { game.active_turn.trade }.by(3) }
    end

    context "combat" do
      it { expect { game.decide(:combat) }.to change { game.active_turn.combat }.by(5) }
    end
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BattleStation.new(game.p1) }
    let(:another_card) { Realms::Cards::Scout.new(game.p1, index: 42) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.p1.deck.discard_pile << another_card
      game.start
      game.play(ally_card)
      game.play(card)
      game.decide(:trade)
      game.ally_ability(card)
    end

    include_examples "scrap_card_from_hand_or_discard_pile"
  end
end
