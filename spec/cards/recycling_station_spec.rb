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
      it { expect { game.decide(:recycling_station, :trade) }.to change { game.active_turn.trade }.by(1) }
    end

    context "discard to draw" do
      before do
        game.decide(:recycling_station, :discard_to_draw)
      end

      context "discard 1" do
        it {
          expect {
            game.decide(:discard_to_draw, game.active_player.hand.sample)
            game.decide(:discard_to_draw, :none)
          }.to change { game.active_player.draw_pile.length }.by(-1).and \
               change { game.active_player.hand.length }.by(0)
        }
      end

      context "discard 2" do
        it {
          expect {
            top_of_deck = game.active_player.draw_pile.first
            c1, c2 = game.active_player.hand.sample(2)
            game.decide(:discard_to_draw, c1)
            expect(game._current_choice.options.map(&:key)).to_not include(top_of_deck.key)
            expect(c1).to_not eq(c2)
            game.decide(:discard_to_draw, c2)
          }.to change { game.active_player.draw_pile.length }.by(-2).and \
               change { game.active_player.hand.length }.by(0)
        }
      end
    end
  end
end
