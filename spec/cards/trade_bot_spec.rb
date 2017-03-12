require "spec_helper"

RSpec.describe Realms::Cards::TradeBot do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :machine_cult
  include_examples "cost", 1

  describe "#primary_ability" do
    let(:another_card) { Realms::Cards::Scout.new(game.p1, index: 42) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.discard_pile << another_card
      game.start
      expect { game.play(card) }.to change { game.active_turn.trade }.by(1)
    end

    include_examples "scrap_card_from_hand_or_discard_pile"
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BattleStation.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(ally_card)
      game.play(card)
      game.decide(:none)
    end

    it { expect { game.ally_ability(card) }.to change { game.active_turn.combat }.by(2) }
  end
end
