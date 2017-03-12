require "spec_helper"

RSpec.describe Realms::Cards::BlobWorld do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :base
  include_examples "defense", 7
  include_examples "factions", :blob
  include_examples "cost", 8

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
    end

    context "choosing nothing" do
      it "does nothing" do
        game.start
        game.play(card)
        expect(game.active_turn.combat).to eq(0)
      end
    end

    context "choosing combat" do
      it "adds 5 combat" do
        game.start
        game.play(card)
        game.base_ability(card)
        expect { game.decide(:combat) }.to change { game.active_turn.combat }.by(5)
      end
    end

    context "choosing to draw" do
      context "when played alone" do
        it "draws 1" do
          game.start
          game.play(card)
          game.base_ability(card)
          expect { game.decide(:draw_for_each_blob_card_played_this_turn) }.to change { game.p1.deck.hand.length }.by(1)
        end
      end

      context "having just played a blob" do
        let(:blob_card) { Realms::Cards::BlobWheel.new(game.p1) }

        before do
          game.p1.deck.hand << blob_card
        end

        it "draws 2" do
          game.start
          game.play(card)
          game.play(blob_card)
          game.base_ability(card)
          expect { game.decide(:draw_for_each_blob_card_played_this_turn) }.to change { game.p1.deck.hand.length }.by(2)
        end
      end

      context "playing a blob afterwards" do
        let(:blob_card) { Realms::Cards::BlobWheel.new(game.p1) }

        before do
          game.p1.deck.hand << blob_card
        end

        it "draws 2" do
          game.start
          game.play(card)
          game.base_ability(card)
          expect { game.decide(:draw_for_each_blob_card_played_this_turn) }.to change { game.p1.deck.hand.length }.by(1)
          expect { game.play(blob_card) }.to change { game.p1.deck.hand.length }.by(-1)
        end
      end

      xcontext "already in play" do
        it "only draws for blobs played this turn"
      end
    end
  end
end
