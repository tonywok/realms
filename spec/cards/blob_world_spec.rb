require "spec_helper"

RSpec.describe Realms::Cards::BlobWorld do
  include_examples "type", :base
  include_examples "defense", 7
  include_examples "factions", :blob
  include_examples "cost", 8

  describe "#primary_ability" do
    include_context "primary_ability" do
      let(:blob_card) { Realms::Cards::BlobWheel.new(game.p1) }
      before do
        game.p1.hand << blob_card
        game.play(card)
      end
    end

    context "choosing nothing" do
      it "does nothing" do
        game.base_ability(card)
        expect { game.decide(:none) }.to change { game.active_turn.combat }.by(0)
      end
    end

    context "choosing combat" do
      it "adds 5 combat" do
        game.base_ability(card)
        expect { game.decide(:combat) }.to change { game.active_turn.combat }.by(5)
      end
    end

    context "choosing to draw" do
      context "when played alone" do
        it "draws 1" do
          game.base_ability(card)
          expect { game.decide(:draw_for_each_blob_card_played_this_turn) }.to change { game.p1.deck.hand.length }.by(1)
        end
      end

      context "having just played a blob" do
        it "draws 2" do
          game.play(blob_card)
          game.base_ability(card)
          expect { game.decide(:draw_for_each_blob_card_played_this_turn) }.to change { game.p1.deck.hand.length }.by(2)
        end
      end

      context "playing a blob afterwards" do
        let(:blob_card) { Realms::Cards::BlobWheel.new(game.p1) }
        it "draws 1" do
          game.base_ability(card)
          expect { game.decide(:draw_for_each_blob_card_played_this_turn) }.to change { game.p1.deck.hand.length }.by(1)
          expect { game.play(blob_card) }.to change { game.p1.deck.hand.length }.by(-1)
        end
      end

      context "already in play" do
        it "only draws for blobs played this turn" do
          game.base_ability(card)
          game.decide(:none)
          game.end_turn # p2 turn
          game.end_turn # p1 turn again

          some_card = game.p1.hand.sample
          game.p1.deck.hand << blob_card
          game.play(some_card)
          expect { game.play(blob_card) }.to change { game.p1.deck.hand.length }.by(-1)

          game.base_ability(card)
          expect { game.decide(:draw_for_each_blob_card_played_this_turn) }.to change { game.p1.deck.hand.length }.by(1)
        end
      end
    end
  end
end
