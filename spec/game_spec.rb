require "spec_helper"

RSpec.describe Realms::Game do
  let(:seed) { 42 }
  let(:game) { described_class.new(seed: seed) }
  let(:p1) { game.active_player }
  let(:p2) { game.passive_player }

  context "collecting events" do
    it "returns the game events that occurred as a result of a decision" do
      events = []
      game.subscribe do |event|
        events << event
      end

      game.start

      expect(events.length).to eq(13)
      expect(events[0]).to have_event(0, :zone_transfer, card: :federation_shuttle_0, source: "trade_deck.draw_pile", destination: "trade_deck.trade_row")
      expect(events[1]).to have_event(1, :zone_transfer, card: :imperial_fighter_2, source: "trade_deck.draw_pile", destination: "trade_deck.trade_row")
      expect(events[2]).to have_event(2, :zone_transfer, card: :barter_world_0, source: "trade_deck.draw_pile", destination: "trade_deck.trade_row")
      expect(events[3]).to have_event(3, :zone_transfer, card: :blob_destroyer_1, source: "trade_deck.draw_pile", destination: "trade_deck.trade_row")
      expect(events[4]).to have_event(4, :zone_transfer, card: :trade_bot_0, source: "trade_deck.draw_pile", destination: "trade_deck.trade_row")
      expect(events[5]).to have_event(5, :zone_transfer, card: :viper_0, source: "p1.draw_pile", destination: "p1.hand")
      expect(events[6]).to have_event(6, :zone_transfer, card: :scout_1, source: "p1.draw_pile", destination: "p1.hand")
      expect(events[7]).to have_event(7, :zone_transfer, card: :scout_5, source: "p1.draw_pile", destination: "p1.hand")
      expect(events[8]).to have_event(8, :zone_transfer, card: :scout_8, source: "p2.draw_pile", destination: "p2.hand")
      expect(events[9]).to have_event(9, :zone_transfer, card: :scout_9, source: "p2.draw_pile", destination: "p2.hand")
      expect(events[10]).to have_event(10, :zone_transfer, card: :viper_2, source: "p2.draw_pile", destination: "p2.hand")
      expect(events[11]).to have_event(11, :zone_transfer, card: :scout_13, source: "p2.draw_pile", destination: "p2.hand")
      expect(events[12]).to have_event(12, :zone_transfer, card: :scout_11, source: "p2.draw_pile", destination: "p2.hand")

      game.decide(:play, :viper_0)

      expect(events[13]).to have_event(13, :zone_transfer, card: :viper_0, source: "p1.hand", destination: "p1.in_play")
      expect(events[14]).to have_event(14, :combat)
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

  describe 'Game 1 test' do
    let(:seed) { 337528643544294302828423678596897352772 }
    let(:game) { described_class.new(seed: seed) }
    it 'plays successfully' do
      game.start
      game.decide(:play, :scout_5)
      game.decide(:play, :scout_3)
      game.decide(:play, :scout_2)
      game.decide(:acquire, :supply_bot_1)
      game.decide(:end_turn)
      game.decide(:play, :viper_2)
      game.decide(:play, :scout_12)
      game.decide(:play, :scout_14)
      game.decide(:play, :scout_13)
      game.decide(:play, :scout_11)
      game.decide(:attack, :p1)
      game.decide(:acquire, :freighter_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_7)
      game.decide(:play, :scout_4)
      game.decide(:play, :scout_6)
      game.decide(:play, :viper_1)
      game.decide(:play, :scout_1)
      game.decide(:attack, :p2)
      game.decide(:acquire, :patrol_mech_1)
      game.decide(:end_turn)
      game.decide(:play, :scout_8)
      game.decide(:play, :viper_3)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_10)
      game.decide(:play, :scout_15)
      game.decide(:attack, :p1)
      game.decide(:acquire, :blob_wheel_1)
      game.decide(:end_turn)
      game.decide(:play, :viper_0)
      game.decide(:play, :scout_0)
      game.decide(:play, :scout_5)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :trade)
      game.decide(:play, :scout_1)
      game.decide(:attack, :p2)
      game.decide(:acquire, :defense_center_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_10)
      game.decide(:play, :viper_2)
      game.decide(:play, :scout_15)
      game.decide(:play, :freighter_0)
      game.decide(:play, :scout_8)
      game.decide(:attack, :p1)
      game.decide(:acquire, :blob_wheel_0)
      game.decide(:acquire, :blob_destroyer_1)
      game.decide(:end_turn)
      game.decide(:play, :scout_3)
      game.decide(:play, :viper_1)
      game.decide(:play, :scout_7)
      game.decide(:play, :scout_6)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :viper_0)
      game.decide(:attack, :p2)
      game.decide(:acquire, :trade_pod_0)
      game.decide(:acquire, :federation_shuttle_1)
      game.decide(:acquire, :federation_shuttle_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_13)
      game.decide(:play, :scout_11)
      game.decide(:play, :blob_wheel_1)
      game.decide(:play, :viper_3)
      game.decide(:scrap_ability, :blob_wheel_1)
      game.decide(:attack, :p1)
      game.decide(:acquire, :corvette_0)
      game.decide(:acquire, :trade_pod_2)
      game.decide(:acquire, :cutter_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_2)
      game.decide(:play, :scout_4)
      game.decide(:play, :scout_1)
      game.decide(:play, :scout_6)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :trade)
      game.decide(:acquire, :royal_redoubt_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_12)
      game.decide(:play, :scout_14)
      game.decide(:play, :viper_2)
      game.decide(:play, :corvette_0)
      game.decide(:play, :freighter_0)
      game.decide(:play, :scout_10)
      game.decide(:attack, :p1)
      game.decide(:acquire, :battle_station_1)
      game.decide(:acquire, :space_station_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_5)
      game.decide(:play, :trade_pod_0)
      game.decide(:play, :defense_center_0)
      game.decide(:play, :federation_shuttle_0)
      game.decide(:play, :scout_7)
      game.decide(:primary_ability, :defense_center_0)
      game.decide(:defense_center, :authority)
      game.decide(:attack, :p2)
      game.decide(:acquire, :flagship_0)
      game.decide(:end_turn)
      game.decide(:play, :blob_wheel_0)
      game.decide(:play, :scout_8)
      game.decide(:play, :scout_11)
      game.decide(:play, :scout_15)
      game.decide(:play, :viper_3)
      game.decide(:scrap_ability, :blob_wheel_0)
      game.decide(:acquire, :missile_bot_2)
      game.decide(:acquire, :imperial_fighter_1)
      game.decide(:acquire, :supply_bot_2)
      game.decide(:end_turn)
      game.decide(:play, :scout_3)
      game.decide(:play, :federation_shuttle_1)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_0)
      game.decide(:play, :viper_1)
      game.decide(:primary_ability, :defense_center_0)
      game.decide(:defense_center, :authority)
      game.decide(:attack, :p2)
      game.decide(:acquire, :the_hive_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_13)
      game.decide(:play, :blob_destroyer_1)
      game.decide(:play, :cutter_0)
      game.decide(:play, :trade_pod_2)
      game.decide(:ally_ability, :blob_destroyer_1)
      game.decide(:destroy_target_base, :none)
      game.decide(:scrap_card_from_trade_row, :central_office_0)
      game.decide(:attack, :defense_center_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :battle_pod_1)
      game.decide(:acquire, :patrol_mech_0)
      game.decide(:acquire, :trade_bot_2)
      game.decide(:end_turn)
      game.decide(:play, :scout_3)
      game.decide(:play, :trade_pod_0)
      game.decide(:play, :federation_shuttle_1)
      game.decide(:play, :royal_redoubt_0)
      game.decide(:play, :scout_1)
      game.decide(:attack, :p2)
      game.decide(:acquire, :cutter_2)
      game.decide(:acquire, :missile_bot_0)
      game.decide(:acquire, :embassy_yacht_1)
      game.decide(:end_turn)
      game.decide(:play, :space_station_0)
      game.decide(:play, :patrol_mech_0)
      game.decide(:patrol_mech, :combat)
      game.decide(:play, :scout_10)
      game.decide(:play, :scout_13)
      game.decide(:play, :scout_8)
      game.decide(:scrap_ability, :space_station_0)
      game.decide(:attack, :royal_redoubt_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :war_world_0)
      game.decide(:acquire, :battle_pod_0)
      game.decide(:end_turn)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :trade)
      game.decide(:play, :federation_shuttle_0)
      game.decide(:play, :scout_2)
      game.decide(:play, :viper_1)
      game.decide(:play, :the_hive_0)
      game.decide(:attack, :p2)
      game.decide(:acquire, :battlecruiser_0)
      game.decide(:end_turn)
      game.decide(:play, :missile_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :viper_3)
      game.decide(:play, :trade_pod_2)
      game.decide(:play, :viper_2)
      game.decide(:play, :battle_pod_1)
      game.decide(:scrap_card_from_trade_row, :port_of_call_0)
      game.decide(:attack, :the_hive_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :ram_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_7)
      game.decide(:play, :flagship_0)
      game.decide(:play, :scout_4)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_5)
      game.decide(:play, :scout_6)
      game.decide(:attack, :p2)
      game.decide(:acquire, :battle_mech_0)
      game.decide(:end_turn)
      game.decide(:play, :supply_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :viper_2)
      game.decide(:play, :trade_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_8)
      game.decide(:play, :cutter_0)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_11)
      game.decide(:attack, :p1)
      game.decide(:acquire, :trade_bot_0)
      game.decide(:acquire, :imperial_fighter_2)
      game.decide(:acquire, :trade_bot_1)
      game.decide(:acquire, :survey_ship_1)
      game.decide(:acquire, :blob_fighter_1)
      game.decide(:end_turn)
      game.decide(:play, :the_hive_0)
      game.decide(:play, :viper_1)
      game.decide(:play, :scout_1)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :combat)
      game.decide(:play, :battlecruiser_0)
      game.decide(:play, :scout_2)
      game.decide(:attack, :p2)
      game.decide(:acquire, :missile_bot_1)
      game.decide(:scrap_ability, :battlecruiser_0)
      game.decide(:destroy_target_base, :the_hive_0)
      game.decide(:play, :battle_mech_0)
      game.decide(:scrap_from_hand_or_discard_pile, :none)
      game.decide(:ally_ability, :patrol_mech_1)
      game.decide(:scrap_from_hand_or_discard_pile, :none)
      game.decide(:ally_ability, :battle_mech_0)
      game.decide(:play, :cutter_2)
      game.decide(:attack, :p2)
      game.decide(:acquire, :cutter_1)
      game.decide(:end_turn)
      game.decide(:play, :scout_15)
      game.decide(:play, :freighter_0)
      game.decide(:play, :scout_14)
      game.decide(:play, :battle_station_1)
      game.decide(:play, :corvette_0)
      game.decide(:play, :blob_destroyer_1)
      game.decide(:scrap_ability, :battle_station_1)
      game.decide(:attack, :p1)
      game.decide(:acquire, :trade_escort_0)
      game.decide(:acquire, :blob_fighter_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_4)
      game.decide(:play, :scout_6)
      game.decide(:play, :federation_shuttle_0)
      game.decide(:play, :federation_shuttle_1)
      game.decide(:play, :trade_pod_0)
      game.decide(:acquire, :fleet_hq_0)
      game.decide(:acquire, :federation_shuttle_2)
      game.decide(:end_turn)
      game.decide(:play, :scout_12)
      game.decide(:play, :imperial_fighter_1)
      game.decide(:play, :battle_pod_0)
      game.decide(:scrap_card_from_trade_row, :trade_pod_1)
      game.decide(:play, :scout_13)
      game.decide(:play, :trade_escort_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :explorer_0)
      game.decide(:end_turn)
      game.decide(:discard, :defense_center_0)
      game.decide(:play, :scout_3)
      game.decide(:play, :scout_7)
      game.decide(:play, :embassy_yacht_1)
      game.decide(:play, :missile_bot_0)
      game.decide(:scrap_from_hand_or_discard_pile, :federation_shuttle_2)
      game.decide(:attack, :p2)
      game.decide(:acquire, :battle_station_0)
      game.decide(:end_turn)
      game.decide(:play, :trade_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_9)
      game.decide(:play, :ram_0)
      game.decide(:play, :blob_fighter_0)
      game.decide(:ally_ability, :blob_fighter_0)
      game.decide(:play, :missile_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_12)
      game.decide(:play, :freighter_0)
      game.decide(:acquire, :recycling_station_0)
      game.decide(:attack, :p1)
      game.decide(:end_turn)
      game.decide(:play, :flagship_0)
      game.decide(:play, :royal_redoubt_0)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_1)
      game.decide(:play, :fleet_hq_0)
      game.decide(:play, :the_hive_0)
      game.decide(:ally_ability, :royal_redoubt_0)
      game.decide(:attack, :p2)
      game.decide(:acquire, :explorer_1)
      game.decide(:end_turn)
      game.decide(:discard, :trade_bot_2)
      game.decide(:play, :corvette_0)
      game.decide(:play, :battle_pod_1)
      game.decide(:scrap_card_from_trade_row, :brain_world_0)
      game.decide(:play, :war_world_0)
      game.decide(:play, :blob_destroyer_1)
      game.decide(:ally_ability, :blob_destroyer_1)
      game.decide(:destroy_target_base, :royal_redoubt_0)
      game.decide(:scrap_card_from_trade_row, :command_ship_0)
      game.decide(:play, :patrol_mech_0)
      game.decide(:patrol_mech, :combat)
      game.decide(:attack, :p1)
    end
  end

  describe 'Game 2 test' do
    let(:seed) { 337528643544294302828423678596897352772 }
    let(:game) { described_class.new(seed: seed) }
    it 'plays successfully' do
      game.start
      game.decide(:play, :scout_5)
      game.decide(:play, :scout_3)
      game.decide(:play, :scout_2)
      game.decide(:acquire, :supply_bot_1)
      game.decide(:end_turn)
      game.decide(:play, :viper_2)
      game.decide(:play, :scout_12)
      game.decide(:play, :scout_14)
      game.decide(:play, :scout_13)
      game.decide(:play, :scout_11)
      game.decide(:attack, :p1)
      game.decide(:acquire, :freighter_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_7)
      game.decide(:play, :scout_4)
      game.decide(:play, :scout_6)
      game.decide(:play, :viper_1)
      game.decide(:play, :scout_1)
      game.decide(:attack, :p2)
      game.decide(:acquire, :patrol_mech_1)
      game.decide(:end_turn)
      game.decide(:play, :scout_8)
      game.decide(:play, :viper_3)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_10)
      game.decide(:play, :scout_15)
      game.decide(:attack, :p1)
      game.decide(:acquire, :blob_wheel_1)
      game.decide(:end_turn)
      game.decide(:play, :viper_0)
      game.decide(:play, :scout_0)
      game.decide(:play, :scout_5)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :trade)
      game.decide(:play, :scout_1)
      game.decide(:attack, :p2)
      game.decide(:acquire, :defense_center_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_10)
      game.decide(:play, :viper_2)
      game.decide(:play, :scout_15)
      game.decide(:play, :freighter_0)
      game.decide(:play, :scout_8)
      game.decide(:attack, :p1)
      game.decide(:acquire, :blob_wheel_0)
      game.decide(:acquire, :blob_destroyer_1)
      game.decide(:end_turn)
      game.decide(:play, :scout_3)
      game.decide(:play, :viper_1)
      game.decide(:play, :scout_7)
      game.decide(:play, :scout_6)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :viper_0)
      game.decide(:attack, :p2)
      game.decide(:acquire, :trade_pod_0)
      game.decide(:acquire, :federation_shuttle_1)
      game.decide(:acquire, :federation_shuttle_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_13)
      game.decide(:play, :scout_11)
      game.decide(:play, :blob_wheel_1)
      game.decide(:play, :viper_3)
      game.decide(:scrap_ability, :blob_wheel_1)
      game.decide(:attack, :p1)
      game.decide(:acquire, :corvette_0)
      game.decide(:acquire, :trade_pod_2)
      game.decide(:acquire, :cutter_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_2)
      game.decide(:play, :scout_4)
      game.decide(:play, :scout_1)
      game.decide(:play, :scout_6)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :trade)
      game.decide(:acquire, :royal_redoubt_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_12)
      game.decide(:play, :scout_14)
      game.decide(:play, :viper_2)
      game.decide(:play, :corvette_0)
      game.decide(:play, :freighter_0)
      game.decide(:play, :scout_10)
      game.decide(:attack, :p1)
      game.decide(:acquire, :battle_station_1)
      game.decide(:acquire, :space_station_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_5)
      game.decide(:play, :trade_pod_0)
      game.decide(:play, :defense_center_0)
      game.decide(:play, :federation_shuttle_0)
      game.decide(:play, :scout_7)
      game.decide(:primary_ability, :defense_center_0)
      game.decide(:defense_center, :authority)
      game.decide(:attack, :p2)
      game.decide(:acquire, :flagship_0)
      game.decide(:end_turn)
      game.decide(:play, :blob_wheel_0)
      game.decide(:play, :scout_8)
      game.decide(:play, :scout_11)
      game.decide(:play, :scout_15)
      game.decide(:play, :viper_3)
      game.decide(:scrap_ability, :blob_wheel_0)
      game.decide(:acquire, :missile_bot_2)
      game.decide(:acquire, :imperial_fighter_1)
      game.decide(:acquire, :supply_bot_2)
      game.decide(:end_turn)
      game.decide(:play, :scout_3)
      game.decide(:play, :federation_shuttle_1)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_0)
      game.decide(:play, :viper_1)
      game.decide(:primary_ability, :defense_center_0)
      game.decide(:defense_center, :authority)
      game.decide(:attack, :p2)
      game.decide(:acquire, :the_hive_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_13)
      game.decide(:play, :blob_destroyer_1)
      game.decide(:play, :cutter_0)
      game.decide(:play, :trade_pod_2)
      game.decide(:ally_ability, :blob_destroyer_1)
      game.decide(:destroy_target_base, :none)
      game.decide(:scrap_card_from_trade_row, :central_office_0)
      game.decide(:attack, :defense_center_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :battle_pod_1)
      game.decide(:acquire, :patrol_mech_0)
      game.decide(:acquire, :trade_bot_2)
      game.decide(:end_turn)
      game.decide(:play, :scout_3)
      game.decide(:play, :trade_pod_0)
      game.decide(:play, :federation_shuttle_1)
      game.decide(:play, :royal_redoubt_0)
      game.decide(:play, :scout_1)
      game.decide(:attack, :p2)
      game.decide(:acquire, :cutter_2)
      game.decide(:acquire, :missile_bot_0)
      game.decide(:acquire, :embassy_yacht_1)
      game.decide(:end_turn)
      game.decide(:play, :space_station_0)
      game.decide(:play, :patrol_mech_0)
      game.decide(:patrol_mech, :combat)
      game.decide(:play, :scout_10)
      game.decide(:play, :scout_13)
      game.decide(:play, :scout_8)
      game.decide(:scrap_ability, :space_station_0)
      game.decide(:attack, :royal_redoubt_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :war_world_0)
      game.decide(:acquire, :battle_pod_0)
      game.decide(:end_turn)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :trade)
      game.decide(:play, :federation_shuttle_0)
      game.decide(:play, :scout_2)
      game.decide(:play, :viper_1)
      game.decide(:play, :the_hive_0)
      game.decide(:attack, :p2)
      game.decide(:acquire, :battlecruiser_0)
      game.decide(:end_turn)
      game.decide(:play, :missile_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :viper_3)
      game.decide(:play, :trade_pod_2)
      game.decide(:play, :viper_2)
      game.decide(:play, :battle_pod_1)
      game.decide(:scrap_card_from_trade_row, :port_of_call_0)
      game.decide(:attack, :the_hive_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :ram_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_7)
      game.decide(:play, :flagship_0)
      game.decide(:play, :scout_4)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_5)
      game.decide(:play, :scout_6)
      game.decide(:attack, :p2)
      game.decide(:acquire, :battle_mech_0)
      game.decide(:end_turn)
      game.decide(:play, :supply_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :viper_2)
      game.decide(:play, :trade_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_8)
      game.decide(:play, :cutter_0)
      game.decide(:play, :scout_9)
      game.decide(:play, :scout_11)
      game.decide(:attack, :p1)
      game.decide(:acquire, :trade_bot_0)
      game.decide(:acquire, :imperial_fighter_2)
      game.decide(:acquire, :trade_bot_1)
      game.decide(:acquire, :survey_ship_1)
      game.decide(:acquire, :blob_fighter_1)
      game.decide(:end_turn)
      game.decide(:play, :the_hive_0)
      game.decide(:play, :viper_1)
      game.decide(:play, :scout_1)
      game.decide(:play, :patrol_mech_1)
      game.decide(:patrol_mech, :combat)
      game.decide(:play, :battlecruiser_0)
      game.decide(:play, :scout_2)
      game.decide(:attack, :p2)
      game.decide(:acquire, :missile_bot_1)
      game.decide(:scrap_ability, :battlecruiser_0)
      game.decide(:destroy_target_base, :the_hive_0)
      game.decide(:play, :battle_mech_0)
      game.decide(:scrap_from_hand_or_discard_pile, :none)
      game.decide(:ally_ability, :patrol_mech_1)
      game.decide(:scrap_from_hand_or_discard_pile, :none)
      game.decide(:ally_ability, :battle_mech_0)
      game.decide(:play, :cutter_2)
      game.decide(:attack, :p2)
      game.decide(:acquire, :cutter_1)
      game.decide(:end_turn)
      game.decide(:play, :scout_15)
      game.decide(:play, :freighter_0)
      game.decide(:play, :scout_14)
      game.decide(:play, :battle_station_1)
      game.decide(:play, :corvette_0)
      game.decide(:play, :blob_destroyer_1)
      game.decide(:scrap_ability, :battle_station_1)
      game.decide(:attack, :p1)
      game.decide(:acquire, :trade_escort_0)
      game.decide(:acquire, :blob_fighter_0)
      game.decide(:end_turn)
      game.decide(:play, :scout_4)
      game.decide(:play, :scout_6)
      game.decide(:play, :federation_shuttle_0)
      game.decide(:play, :federation_shuttle_1)
      game.decide(:play, :trade_pod_0)
      game.decide(:acquire, :fleet_hq_0)
      game.decide(:acquire, :federation_shuttle_2)
      game.decide(:end_turn)
      game.decide(:play, :scout_12)
      game.decide(:play, :imperial_fighter_1)
      game.decide(:play, :battle_pod_0)
      game.decide(:scrap_card_from_trade_row, :trade_pod_1)
      game.decide(:play, :scout_13)
      game.decide(:play, :trade_escort_0)
      game.decide(:attack, :p1)
      game.decide(:acquire, :explorer_0)
      game.decide(:end_turn)
      game.decide(:discard, :defense_center_0)
      game.decide(:play, :scout_3)
      game.decide(:play, :scout_7)
      game.decide(:play, :embassy_yacht_1)
      game.decide(:play, :missile_bot_0)
      game.decide(:scrap_from_hand_or_discard_pile, :federation_shuttle_2)
      game.decide(:attack, :p2)
      game.decide(:acquire, :battle_station_0)
      game.decide(:end_turn)
      game.decide(:play, :trade_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_9)
      game.decide(:play, :ram_0)
      game.decide(:play, :blob_fighter_0)
      game.decide(:ally_ability, :blob_fighter_0)
      game.decide(:play, :missile_bot_2)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_12)
      game.decide(:play, :freighter_0)
      game.decide(:acquire, :recycling_station_0)
      game.decide(:attack, :p1)
      game.decide(:end_turn)
      game.decide(:play, :flagship_0)
      game.decide(:play, :royal_redoubt_0)
      game.decide(:play, :supply_bot_1)
      game.decide(:scrap_from_hand_or_discard_pile, :scout_1)
      game.decide(:play, :fleet_hq_0)
      game.decide(:play, :the_hive_0)
      game.decide(:ally_ability, :royal_redoubt_0)
      game.decide(:attack, :p2)
      game.decide(:acquire, :explorer_1)
      game.decide(:end_turn)
      game.decide(:discard, :trade_bot_2)
      game.decide(:play, :corvette_0)
      game.decide(:play, :battle_pod_1)
      game.decide(:scrap_card_from_trade_row, :brain_world_0)
      game.decide(:play, :war_world_0)
      game.decide(:play, :blob_destroyer_1)
      game.decide(:ally_ability, :blob_destroyer_1)
      game.decide(:destroy_target_base, :royal_redoubt_0)
      game.decide(:scrap_card_from_trade_row, :command_ship_0)
      game.decide(:play, :patrol_mech_0)
      game.decide(:patrol_mech, :combat)
      game.decide(:attack, :p1)
    end
  end
end
