require "spec_helper"

RSpec.describe Realms::Cards::RecyclingStation do
  include_examples "type", :outpost
  include_examples "defense", 4
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 4

  describe "#primary_ability" do
    include_context "base_ability" do
      before do
        game.base_ability(card)
      end
    end

    context "trade" do
      it { expect { game.decide(:trade) }.to change { game.active_turn.trade }.by(1) }
    end

    context "discard to draw" do
      before do
        game.decide(:discard_to_draw)
      end

      context "discard 1" do
        it {
          expect {
            game.decide(game.p1.hand.sample.key)
            game.decide(:none)
          }.to change { game.p1.draw_pile.length }.by(-1).and \
               change { game.p1.hand.length }.by(0)
        }
      end

      context "discard 2" do
        it {
          expect {
            top_of_deck = game.p1.deck.draw_pile.first
            c1, c2 = game.p1.hand.sample(2)
            game.decide(c1.key)
            expect(game.current_choice.options.values.map(&:key)).to_not include(top_of_deck.key)
            expect(c1).to_not eq(c2)
            game.decide(c2.key)
          }.to change { game.p1.draw_pile.length }.by(-2).and \
               change { game.p1.hand.length }.by(0)
        }
      end
    end
  end
end
