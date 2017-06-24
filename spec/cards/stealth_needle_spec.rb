require "spec_helper"

RSpec.describe Realms::Cards::StealthNeedle do
  include_examples "factions", :machine_cult
  include_examples "cost", 4

  describe "#primary_ability" do
    let(:another_ship) { Realms::Cards::Cutter.new(game.p1) }

    before do
      game.p1.hand << another_ship
    end

    include_context "primary_ability"

    context "no ships" do
      it "is just machine cult card with no abilities" do
        game.play(card)
        expect(card.factions).to contain_exactly(:machine_cult)
      end
    end

    context "copying a ship" do
      it "copies another ship played this turn" do
        expect {
          game.play(another_ship)
        }.to change { game.active_turn.trade }.by(2).and \
             change { game.p1.authority }.by(4)

        game.play(card)
        expect(game.current_choice.options.keys).to_not include(card.key)

        expect {
          game.decide(another_ship.key)
        }.to change { game.active_turn.trade }.by(2).and \
             change { game.p1.authority }.by(4).and \
             change { game.active_turn.combat }.by(8)

        expect(card.factions).to contain_exactly(:trade_federation, :machine_cult)

        game.end_turn

        expect(card.factions).to contain_exactly(:machine_cult)
      end

      context "multiple stealth needles, why not" do
        it "can copy an already copied stealth needle" do
          another_stealth_needle = Realms::Cards::StealthNeedle.new(game.p1, index: 1)
          game.p1.hand << another_stealth_needle

          expect {
            game.play(another_ship)
          }.to change { game.p1.authority }.by(4).and \
               change { game.active_turn.trade }.by(2)

          game.play(card)

          expect {
            game.decide(another_ship.key)
          }.to change { game.p1.authority }.by(4).and \
               change { game.active_turn.trade }.by(2)
               change { game.active_turn.combat }.by(8)

          game.play(another_stealth_needle)

          expect {
            game.decide(card.key)
          }.to change { game.p1.authority }.by(4).and \
               change { game.active_turn.trade }.by(2).and \
               change { game.active_turn.combat }.by(4)

          game.end_turn

          [card, another_stealth_needle].each do |c|
            expect(c.factions).to contain_exactly(:machine_cult)
            expect(c.definition.primary_abilities).to be_one
            expect(c.definition.primary_abilities.first.key).to eq(:copy_ship)
            expect(c.definition).to eq(c.class.definition)
          end
        end
      end
    end
  end
end
