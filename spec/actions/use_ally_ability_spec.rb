require "spec_helper"

RSpec.describe Realms2::Actions::UseAllyAbility do
  let(:game) { Realms2::Game.new }

  context "when playing two different, same faction cards" do
    let(:card1) { Realms2::Cards::BlobFighter.new(game.p1) }
    let(:card2) { Realms2::Cards::BattlePod.new(game.p1) }

    before do
      game.p1.deck.hand << card1
      game.p1.deck.hand << card2
      game.start
    end

    it "triggers both cards" do
      game.decide(:play, :blob_fighter_0)
      expect(game.current_choice.options[:ally]).to_not have_key(:blob_fighter_0)
      game.decide(:play, :battle_pod_0)
      game.decide(:scout_0)
      expect(game.current_choice.options[:ally]).to have_key(:blob_fighter_0)
      expect { game.decide(:ally, :blob_fighter_0) }.to change { game.active_turn.active_player.deck.hand.length }.by(1)
      expect { game.decide(:ally, :battle_pod_0) }.to change { game.active_turn.combat }.by(2)
    end
  end

  context "when playing two of the same card" do
    let(:card1) { Realms2::Cards::BlobFighter.new(game.p1, index: 0) }
    let(:card2) { Realms2::Cards::BlobFighter.new(game.p1, index: 1) }

    before do
      game.p1.deck.hand << card1
      game.p1.deck.hand << card2
      game.start
    end

    it "triggers both cards" do
      game.decide(:play, :blob_fighter_0)
      expect(game.current_choice.options[:ally]).to_not have_key(:blob_fighter_0)
      expect(game.current_choice.options[:ally]).to_not have_key(:blob_fighter_1)
      game.decide(:play, :blob_fighter_1)
      expect(game.current_choice.options[:ally]).to have_key(:blob_fighter_0)
      expect(game.current_choice.options[:ally]).to have_key(:blob_fighter_1)

      expect {
        game.decide(:ally, :blob_fighter_0)
        expect(game.current_choice.options[:ally]).to_not have_key(:blob_fighter_0)
        expect(game.current_choice.options[:ally]).to have_key(:blob_fighter_1)
        game.decide(:ally, :blob_fighter_1)
      }.to change { game.active_turn.active_player.deck.hand.length }.by(2)
    end
  end
end
