require "spec_helper"

RSpec.describe Realms::Game do
  let(:game) { described_class.new }
  let(:p1) { game.active_player }
  let(:p2) { game.passive_player }

  context "observing non player happenings" do
    it "can be subscribed to" do
      zts = []
      game.on(:card_moved) do |zt|
        zts << zt
      end
      game.start
      expect(zts.length).to eq(8)
    end
  end

  context "death by viper" do
    it "plays" do
      game.start

      expect(p1.authority).to eq(50)
      expect(p2.authority).to eq(50)

      expect(p1.deck.hand.length).to eq(3)
      expect(p2.deck.hand.length).to eq(5)

      until game.over?
        hand = game.active_player.hand

        until hand.empty?
          game.play(hand.first)
        end

        game.attack(game.passive_player) if game.active_turn.combat.positive?

        game.end_turn
      end
    end
  end
end
