require "spec_helper"

RSpec.describe Realms::Actions::Attack do
  let(:game) { Realms::Game.new }

  context "opponent has no bases in play" do
    let(:card) { Realms::Cards::Viper.new(game.p1, index: 0) }

    before do
      game.p1.deck.hand << card
      game.start
    end

    it "deals damage to the opponent" do
      expect {
        game.play(card.key)
      }.to change { game.active_turn.combat }.by(1)

      expect {
        game.attack(game.p2.key)
      }.to change { game.p2.authority }.by(-1).and \
           change { game.active_turn.combat }.by(-1)

      expect(game.active_turn.combat).to eq(0)
    end
  end

  context "opponent has a non-output base in play" do
    let(:base) { Realms::Cards::BlobWheel.new(game.p1) }

    before do
      game.p2.deck.battlefield << base
      game.start
      game.active_turn.combat = combat
    end

    context "with combat greater than base defense" do
      let(:combat) { base.defense + 1 }

      it "can attack the base" do
        game.attack(base)
        expect(game.p2.deck.discard_pile).to include(base)
        expect(game.p2.authority).to eq(50)
        game.attack(game.p2)
        expect(game.p2.authority).to eq(49)
      end

      it "can attack the player" do
        game.attack(game.p2)
        expect(game.p2.authority).to eq(44)
      end
    end

    context "with combat equal to base defense" do
      let(:combat) { base.defense }

      it "can attack the base" do
        game.attack(base)
        expect(game.p2.deck.discard_pile).to include(base)
        expect { game.attack(game.p2) }.to raise_error(Realms::Choice::InvalidOption)
      end

      it "can attack the player" do
        game.attack(game.p2)
        expect(game.p2.authority).to eq(45)
      end
    end

    context "with combat less than base defense" do
      let(:combat) { base.defense - 1  }

      it "cannot attack the base" do
        expect { game.attack(base) }.to raise_error(Realms::Choice::InvalidOption)
      end

      it "can attack the player" do
        game.attack(game.p2)
        expect(game.p2.authority).to eq(46)
      end
    end
  end

  context "opponent has an outpost base in play" do
    let(:base) { Realms::Cards::DefenseCenter.new(game.p1) }

    before do
      game.p2.deck.battlefield << base
      game.start
      game.active_turn.combat = combat
    end

    context "with combat greater than base defense" do
      let(:combat) { base.defense + 1 }

      it "can attack the base" do
        game.attack(base)
        expect(game.p2.deck.discard_pile).to include(base)
        expect(game.p2.authority).to eq(50)
        game.attack(game.p2)
        expect(game.p2.authority).to eq(49)
      end

      it "cannot attack the player" do
        expect { game.attack(game.p2) }.to raise_error(Realms::Choice::InvalidOption)
      end
    end

    context "with combat equal to base defense" do
      let(:combat) { base.defense }

      it "can attack the base" do
        game.attack(base)
        expect(game.p2.deck.discard_pile).to include(base)
        expect { game.attack(game.p2) }.to raise_error(Realms::Choice::InvalidOption)
      end

      it "cannot attack the player" do
        expect { game.attack(game.p2) }.to raise_error(Realms::Choice::InvalidOption)
      end
    end

    context "with combat less than base defense" do
      let(:combat) { base.defense - 1  }

      it "cannot attack the base" do
        expect { game.attack(base) }.to raise_error(Realms::Choice::InvalidOption)
      end

      it "cannot attack the player" do
        expect { game.attack(game.p2) }.to raise_error(Realms::Choice::InvalidOption)
      end
    end
  end

  context "opponent has both an outpost and base" do
    let(:base) { Realms::Cards::BlobWheel.new(game.p1) }
    let(:outpost) { Realms::Cards::DefenseCenter.new(game.p1) }

    before do
      game.p2.deck.battlefield << base
      game.p2.deck.battlefield << outpost
      game.start
      game.active_turn.combat = base.defense + outpost.defense + 1
    end

    it "must destroy outpost first" do
      expect { game.attack(base) }.to raise_error(Realms::Choice::InvalidOption)
      expect { game.attack(game.p2) }.to raise_error(Realms::Choice::InvalidOption)
      game.decide(outpost.key)
      game.attack(base)
      game.attack(game.p2)
      expect(game.p2.deck.discard_pile).to include(base)
      expect(game.p2.deck.discard_pile).to include(outpost)
      expect(game.p2.authority).to eq(49)
    end
  end
end
