require "spec_helper"

RSpec.describe Realms::Cards::BlobWorld do
  include_examples "type", :base
  include_examples "defense", 7
  include_examples "factions", :blob
  include_examples "cost", 8

  describe "#primary_ability" do
    include_context "primary_ability" do
      let(:blob_card) { Realms::Cards::BlobWheel.new(game.active_player) }
      before do
        game.active_player.hand << blob_card
        game.play(card)
      end
    end

    context "choosing combat" do
      it "adds 5 combat" do
        game.base_ability(card)
        expect { game.decide(:blob_world, :combat) }.to change { game.active_turn.combat }.by(5)
      end
    end

    context "choosing to draw" do
      context "when played alone" do
        it "draws 1" do
          game.base_ability(card)
          expect { game.decide(:blob_world, :draw_for_each_blob_card_played_this_turn) }.to change { game.active_player.hand.length }.by(1)
        end
      end

      context "having just played a blob" do
        it "draws 2" do
          game.play(blob_card)
          game.base_ability(card)
          expect { game.decide(:blob_world, :draw_for_each_blob_card_played_this_turn) }.to change { game.active_player.hand.length }.by(2)
        end
      end

      context "playing a blob afterwards" do
        let(:blob_card) { Realms::Cards::BlobWheel.new(game.active_player) }
        it "draws 1" do
          game.base_ability(card)
          expect { game.decide(:blob_world, :draw_for_each_blob_card_played_this_turn) }.to change { game.active_player.hand.length }.by(1)
          expect { game.play(blob_card) }.to change { game.active_player.hand.length }.by(-1)
        end
      end

      context "already in play" do
        it "only draws for blobs played this turn" do
          game.end_turn # p2 turn
          game.end_turn # active_player turn again

          some_card = game.active_player.hand.sample
          game.active_player.hand << blob_card
          game.play(some_card)
          expect { game.play(blob_card) }.to change { game.active_player.hand.length }.by(-1)

          game.base_ability(card)
          expect { game.decide(:blob_world, :draw_for_each_blob_card_played_this_turn) }.to change { game.active_player.hand.length }.by(1)
        end
      end
    end
  end
end
