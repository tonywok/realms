require "spec_helper"

RSpec.describe Realms::Game do
  let(:p1) { game.p1 }
  let(:p2) { game.p2 }

  context "death by viper" do
    let(:game) { described_class.new }

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

  context "a seeded game" do
    let(:seed) { 309599894551866961338950272150965224107 }
    let(:game) { described_class.new(seed) }

    it "plays to deterministic completion" do
      game.start

      game.play(:scout_4)
      game.play(:viper_0)
      game.play(:scout_0)
      game.acquire(:explorer_0)
      game.attack(:bear)
      game.end_turn

      game.play(:scout_4)
      game.play(:viper_0)
      game.play(:scout_0)
      game.play(:scout_2)
      game.play(:viper_1)
      game.acquire(:trading_post_1)
      game.attack(:frog)
      game.end_turn

      game.play(:scout_2)
      game.play(:viper_1)
      game.play(:scout_7)
      game.play(:scout_3)
      game.play(:scout_1)
      game.acquire(:freighter_0)
      game.attack(:bear)
      game.end_turn

      game.play(:scout_7)
      game.play(:scout_3)
      game.play(:scout_1)
      game.play(:scout_5)
      game.play(:scout_6)
      game.acquire(:trade_bot_2)
      game.acquire(:blob_wheel_1)
      game.acquire(:blob_fighter_1)
      game.end_turn

      game.play(:scout_5)
      game.play(:scout_6)
      game.play(:scout_0)
      game.play(:scout_3)
      game.play(:freighter_0)
      game.acquire(:brain_world_0)
      game.end_turn

      game.play(:scout_3)
      game.play(:viper_1)
      game.play(:scout_2)
      game.play(:scout_4)
      game.play(:scout_5)
      game.acquire(:explorer_1)
      game.attack(:frog)
      game.acquire(:explorer_2)
      game.end_turn

      game.play(:scout_4)
      game.play(:scout_1)
      game.play(:scout_7)
      game.play(:viper_0)
      game.play(:explorer_0)
      game.acquire(:trade_escort_0)
      game.scrap_ability(:explorer_0)
      game.attack(:bear)
      game.end_turn

      game.play(:trading_post_1)
      game.play(:scout_6)
      game.play(:blob_wheel_1)
      game.play(:blob_fighter_1)
      game.play(:trade_bot_2)
      game.decide(:viper_1)
      game.base_ability(:trading_post_1)
      game.decide(:trade)
      game.base_ability(:blob_wheel_1)
      game.ally_ability(:blob_fighter_1)
      game.play(:scout_1)
      game.acquire(:stealth_needle_0)
      game.attack(:frog)
      game.end_turn

      game.play(:scout_2)
      game.play(:viper_1)
      game.play(:scout_1)
      game.play(:scout_4)
      game.play(:viper_0)
      game.acquire(:survey_ship_2)
      game.end_turn

      game.play(:scout_7)
      game.play(:viper_0)
      game.play(:scout_0)
      game.play(:blob_fighter_1)
      game.play(:scout_6)
      game.base_ability(:trading_post_1)
      game.decide(:trade)
      game.base_ability(:blob_wheel_1)
      game.ally_ability(:blob_fighter_1)
      game.play(:scout_1)
      game.acquire(:federation_shuttle_2)
      game.acquire(:blob_wheel_0)
      game.attack(:frog)
      game.end_turn

      game.play(:scout_0)
      game.play(:brain_world_0)
      game.base_ability(:brain_world_0)
      game.decide(:scout_7)
      game.decide(:scout_6)
      game.play(:trade_escort_0)
      game.play(:scout_5)
      game.play(:scout_3)
      game.acquire(:corvette_0)
      game.attack(:trading_post_1)
      game.end_turn

      game.play(:scout_2)
      game.play(:trade_bot_2)
      game.decide(:viper_0)
      game.play(:scout_3)
      game.play(:explorer_2)
      game.play(:stealth_needle_0)
      game.decide(:trade_bot_2)
      game.decide(:scout_1)
      game.acquire(:blob_carrier_0)
      game.base_ability(:blob_wheel_1)
      game.end_turn
    end
  end
end
