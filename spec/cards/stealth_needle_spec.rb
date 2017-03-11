require "spec_helper"

RSpec.describe Realms::Cards::StealthNeedle do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :machine_cult
  include_examples "cost", 4

  describe "#primary_ability" do
    context "no ships" do
      before do
        game.p1.deck.hand << card
        game.start
      end

      it "is just machine cult card with no abilities" do
        game.decide(:play, card.key)
        expect(card.factions).to contain_exactly(:machine_cult)
      end
    end

    context "copying a ship" do
      let(:another_ship) { Realms::Cards::Cutter.new(game.p1) }

      before do
        game.p1.deck.hand << another_ship
        game.p1.deck.hand << card
        game.start
      end

      it "copies the ship, maintaining faction, until end of turn" do
        expect {
          game.decide(:play, another_ship.key)
        }.to change { game.active_turn.trade }.by(2).and \
             change { game.p1.authority }.by(4)

        game.decide(:play, card.key)

        expect {
          game.decide(another_ship.key)
        }.to change { game.active_turn.trade }.by(2).and \
             change { game.p1.authority }.by(4)

        expect(card.factions).to contain_exactly(:trade_federation, :machine_cult)

        expect {
          game.decide(:ally, another_ship.key)
        }.to change { game.active_turn.combat }.by(4)

        expect {
          game.decide(:ally, card.key)
        }.to change { game.active_turn.combat }.by(4)

        game.decide(:end_turn)

        expect(card.factions).to contain_exactly(:machine_cult)
      end
    end
  end
end
