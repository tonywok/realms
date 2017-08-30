require "spec_helper"

RSpec.describe Realms::Cards::EmbassyYacht do
  include_examples "factions", :trade_federation
  include_examples "cost", 3

  describe "#primary_ability" do
    include_context "primary_ability"

    context "no bases in play" do
      it {
        expect {
          game.play(card)
        }.to change { game.active_player.authority }.by(3).and \
             change { game.active_turn.trade }.by(2)
      }
    end

    context "one base in play" do
      before do
        game.active_player.in_play << Realms::Cards::BlobWheel.new(game.active_player)
      end

      it {
        expect {
          game.play(card)
        }.to change { game.active_player.authority }.by(3).and \
             change { game.active_turn.trade }.by(2)
      }
    end

    context "two bases in play" do
      before do
        game.active_player.in_play << Realms::Cards::BlobWheel.new(game.active_player, index: 0)
        game.active_player.in_play << Realms::Cards::BlobWheel.new(game.active_player, index: 1)
      end

      it {
        expect {
          game.play(card)
        }.to change { game.active_player.authority }.by(3).and \
             change { game.active_turn.trade }.by(2).and \
             change { game.active_player.draw_pile.length }.by(-2)
      }
    end
  end
end
