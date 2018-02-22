require "spec_helper"

RSpec.describe Actions::Attack do
  let(:game) { Game.new }
  let(:combat) { 1 }
  let(:primary_ability) do
    Effects::Definitions::Numeric.new(Effects::Combat, combat)
  end

  let(:card) do
    card = Cards::Viper.new(game.active_player, index: 10)
    card.definition = card.definition.clone.tap do |definition|
      definition.primary_ability = primary_ability
    end
    card
  end

  before do
    game.p1.hand << card
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
        game.attack(game.passive_player.key)
      }.to change { game.passive_player.authority }.by(-1).and \
           change { game.active_turn.combat }.by(-1)

      expect(game.active_turn.combat).to eq(0)
    end
  end

  context "opponent has a non-outpost base in play" do
    let(:base) { Cards::BlobWheel.new(game.active_player) }

    before do
      game.p2.in_play << base
      game.start
      game.play(card)
    end

    context "with combat greater than base defense" do
      let(:combat) { base.defense + 1 }

      it "can attack the base" do
        game.attack(base)
        expect(base.zone).to eq(game.passive_player.discard_pile)
        expect(base.class).to eq(Cards::BlobWheel)
        expect(game.passive_player.authority).to eq(50)
        game.attack(game.passive_player)
        expect(game.passive_player.authority).to eq(49)
      end

      it "can attack the player" do
        game.attack(game.passive_player)
        expect(game.passive_player.authority).to eq(44)
      end
    end

    context "with combat equal to base defense" do
      let(:combat) { base.defense }

      it "can attack the base" do
        game.attack(base)
        expect(game.passive_player.discard_pile).to include(base)
        expect { game.attack(game.passive_player) }.to raise_error(Choices::InvalidOption)
      end

      it "can attack the player" do
        game.attack(game.passive_player)
        expect(game.passive_player.authority).to eq(45)
      end
    end

    context "with combat less than base defense" do
      let(:combat) { base.defense - 1  }

      it "cannot attack the base" do
        expect { game.attack(base) }.to raise_error(Choices::InvalidOption)
      end

      it "can attack the player" do
        game.attack(game.passive_player)
        expect(game.passive_player.authority).to eq(46)
      end
    end
  end

  context "opponent has an outpost base in play" do
    let(:base) { Cards::DefenseCenter.new(game.active_player) }

    before do
      game.p2.in_play << base
      game.start
      game.play(card)
    end

    context "with combat greater than base defense" do
      let(:combat) { base.defense + 1 }

      it "can attack the base" do
        game.attack(base)
        expect(game.passive_player.discard_pile).to include(base)
        expect(game.passive_player.authority).to eq(50)
        game.attack(game.passive_player)
        expect(game.passive_player.authority).to eq(49)
      end

      it "cannot attack the player" do
        expect { game.attack(game.passive_player) }.to raise_error(Choices::InvalidOption)
      end
    end

    context "with combat equal to base defense" do
      let(:combat) { base.defense }

      it "can attack the base" do
        game.attack(base)
        expect(game.passive_player.discard_pile).to include(base)
        expect { game.attack(game.passive_player) }.to raise_error(Choices::InvalidOption)
      end

      it "cannot attack the player" do
        expect { game.attack(game.passive_player) }.to raise_error(Choices::InvalidOption)
      end
    end

    context "with combat less than base defense" do
      let(:combat) { base.defense - 1  }

      it "cannot attack the base" do
        expect { game.attack(base) }.to raise_error(Choices::InvalidOption)
      end

      it "cannot attack the player" do
        expect { game.attack(game.passive_player) }.to raise_error(Choices::InvalidOption)
      end
    end
  end

  context "opponent has both an outpost and base" do
    let(:base) { Cards::BlobWheel.new(game.active_player) }
    let(:outpost) { Cards::DefenseCenter.new(game.active_player) }
    let(:combat) { outpost.defense + outpost.defense + 1 }

    before do
      game.p2.in_play << base
      game.p2.in_play << outpost
      game.start
      game.play(card)
    end

    it "must destroy outpost first" do
      expect { game.attack(base) }.to raise_error(Choices::InvalidOption)
      expect { game.attack(game.passive_player) }.to raise_error(Choices::InvalidOption)
      game.attack(outpost)
      game.attack(base)
      game.attack(game.passive_player)
      expect(game.passive_player.discard_pile).to include(base)
      expect(game.passive_player.discard_pile).to include(outpost)
      expect(game.passive_player.authority).to eq(49)
    end
  end
end
