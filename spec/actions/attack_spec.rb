require "spec_helper"

RSpec.describe Realms::Actions::Attack do
  let(:game) { Realms::Game.new }
  let(:combat) { 1 }
  let(:card) do
    card = Realms::Cards::Viper.new(game.p1, index: 0)
    card.definition = card.definition.clone.tap do |definition|
      definition.primary_abilities = [Realms::Abilities::Combat[combat]]
    end
    card
  end

  before do
    game.p1.deck.hand << card
  end

  context "opponent has no bases in play" do
    before do
      game.start
    end

    it "deals damage to the opponent" do
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(1)

      expect {
        game.attack(game.p2.key)
      }.to change { game.p2.authority }.by(-1).and \
           change { game.active_turn.combat }.by(-1)

      expect(game.active_turn.combat).to eq(0)
    end
  end

  context "opponent has a non-outpost base in play" do
    let(:base) { Realms::Cards::BlobWheel.new(game.p1) }

    before do
      game.p2.deck.battlefield << base
      game.start
      game.play(card)
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
      game.play(card)
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
    let(:combat) { outpost.defense + outpost.defense + 1 }

    before do
      game.p2.deck.battlefield << base
      game.p2.deck.battlefield << outpost
      game.start
      game.play(card)
    end

    it "must destroy outpost first" do
      expect { game.attack(base) }.to raise_error(Realms::Choice::InvalidOption)
      expect { game.attack(game.p2) }.to raise_error(Realms::Choice::InvalidOption)
      game.attack(outpost)
      game.attack(base)
      game.attack(game.p2)
      expect(game.p2.deck.discard_pile).to include(base)
      expect(game.p2.deck.discard_pile).to include(outpost)
      expect(game.p2.authority).to eq(49)
    end
  end
end
