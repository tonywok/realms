require "spec_helper"

RSpec.describe Realms::Cards::BlobWorld do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#type" do
    subject { card.type }
    it { is_expected.to eq(:base) }
  end

  describe "#defense" do
    subject { card.defense }
    it { is_expected.to eq(7) }
  end

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:blob) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(8) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
    end

    context "choosing nothing" do
      it "does nothing" do
        game.start
        game.decide(:play, :blob_world_0)
        expect(game.active_turn.combat).to eq(0)
      end
    end

    context "choosing combat" do
      it "adds 5 combat" do
        game.start
        game.decide(:play, :blob_world_0)
        game.decide(:primary, :blob_world_0)
        expect { game.decide(:option_0) }.to change { game.active_turn.combat }.by(5)
      end
    end

    context "choosing to draw" do
      context "when played alone" do
        it "draws 1" do
          game.start
          game.decide(:play, :blob_world_0)
          game.decide(:primary, :blob_world_0)
          expect { game.decide(:option_1) }.to change { game.p1.deck.hand.length }.by(1)
        end
      end

      context "having just played a blob" do
        let(:another_blob) { Realms::Cards::BlobWheel.new(game.p1) }
        before do
          game.p1.deck.hand << another_blob
        end

        it "draws 2" do
          game.start
          game.decide(:play, :blob_world_0)
          game.decide(:play, :blob_wheel_0)
          game.decide(:primary, :blob_world_0)
          expect { game.decide(:option_1) }.to change { game.p1.deck.hand.length }.by(2)
        end
      end

      context "playing a blob afterwards" do
        let(:another_blob) { Realms::Cards::BlobWheel.new(game.p1) }
        before do
          game.p1.deck.hand << another_blob
        end

        it "draws 2" do
          game.start
          game.decide(:play, :blob_world_0)
          game.decide(:primary, :blob_world_0)
          expect { game.decide(:option_1) }.to change { game.p1.deck.hand.length }.by(1)
          expect { game.decide(:play, :blob_wheel_0) }.to change { game.p1.deck.hand.length }.by(-1)
        end
      end

      xcontext "already in play" do
        it "only draws for blobs played this turn"
      end
    end
  end
end
