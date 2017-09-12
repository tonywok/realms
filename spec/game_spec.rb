require "spec_helper"

RSpec.describe Realms::Game do
  let(:seed) { 42 }
  let(:game) { described_class.new(seed: seed) }
  let(:p1) { game.active_player }
  let(:p2) { game.passive_player }

  context "collecting events" do
    it "returns the game events that occurred as a result of a decision" do
      events = game.start.map { |e| [e.id, e.card.key, e.source.key, e.destination.key] }
      expect(events).to eq([
       [0, :federation_shuttle_0, "trade_deck.draw_pile", "trade_deck.trade_row"],
       [1, :imperial_fighter_2, "trade_deck.draw_pile", "trade_deck.trade_row"],
       [2, :barter_world_0, "trade_deck.draw_pile", "trade_deck.trade_row"],
       [3, :blob_destroyer_1, "trade_deck.draw_pile", "trade_deck.trade_row"],
       [4, :trade_bot_0, "trade_deck.draw_pile", "trade_deck.trade_row"],
       [5, :viper_0, "p1.draw_pile", "p1.hand"],
       [6, :scout_1, "p1.draw_pile", "p1.hand"],
       [7, :scout_5, "p1.draw_pile", "p1.hand"],
       [8, :scout_8, "p2.draw_pile", "p2.hand"],
       [9, :scout_9, "p2.draw_pile", "p2.hand"],
       [10, :viper_2, "p2.draw_pile", "p2.hand"],
       [11, :scout_13, "p2.draw_pile", "p2.hand"],
       [12, :scout_11, "p2.draw_pile", "p2.hand"],
      ])
    end
  end

  context "death by viper" do
    it "plays" do
      game.start

      expect(p1.authority).to eq(50)
      expect(p2.authority).to eq(50)

      expect(p1.hand.length).to eq(3)
      expect(p2.hand.length).to eq(5)

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
