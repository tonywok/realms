require "spec_helper"

RSpec.describe Realms::Game do
  let(:game) { described_class.new }
  let(:p1) { game.p1 }
  let(:p2) { game.p2 }

  context "death by viper" do
    it "plays" do
      game.start

      expect(p1.authority).to eq(50)
      expect(p2.authority).to eq(50)

      expect(p1.deck.hand.length).to eq(3)
      expect(p2.deck.hand.length).to eq(5)

      until game.over?
        turn = game.active_turn
        deck = turn.active_player.deck

        until deck.hand.empty?
          game.play(deck.hand.first)
        end

        game.attack(turn.passive_player) if turn.combat.positive?
        game.end_turn
      end
    end
  end
end
