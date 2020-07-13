require "realms/effects/event"
require "realms/effects/registry"

module Realms
  module Effects
    def self.registry
      @registry ||= Registry.configure do
        effect(:trade, auto: true) do |amount|
          active_turn.trade += amount
        end

        effect(:combat, auto: true) do |amount|
          active_turn.combat += amount
        end

        effect(:authority, auto: true) do |amount|
          active_player.authority += amount
        end

        effect(:draw) do |amount|
          active_player.draw(amount)
        end

        effect(:discard) do |amount|
          passive_player.upkeep << ::Realms::Actions::Discard
        end

        effect(:scrap_from_hand_or_discard_pile) do
          options = active_player.hand.cards + active_player.discard_pile.cards

          choose(options) do |card|
            active_player.scrap(card)
          end
        end

        effect(:destroy_target_base) do
          all_bases = active_player.in_play.select(&:base?) + passive_player.in_play.select(&:base?)
          bases_in_play = all_bases.any?(&:outpost?) ? all_bases.select(&:outpost?) : all_bases
        
          choose(bases_in_play) do |card|
            player = card.owner
            player.destroy(card)
          end
        end

        effect(:scrap_card_from_trade_row) do |amount|
          choose(trade_deck.trade_row.cards, count: 1) do |card|
            active_player.scrap(card)
          end
        end

        effect(:discard_to_draw) do |amount|
          may_choose_many(active_player.hand, count: amount) do |cards|
            cards.each { |card| active_player.discard(card) }
            active_player.draw(cards.length)
          end
        end

        effect(:draw_for_each_scrap_from_hand_or_discard_pile) do |amount|
          cards_in_hand_or_discard_pile = [active_player.hand, active_player.discard_pile].flat_map(&:cards)

          may_choose_many(cards_in_hand_or_discard_pile, count: amount) do |cards|
            cards.each { |selected_card| trade_deck.scrap(selected_card) }
            active_player.draw(cards.length)
          end
        end

        effect(:draw_then_scrap_from_hand) do |amount|
          amount.times do
            active_player.draw
            choose(active_player.hand)do |chosen_card|
              active_player.scrap(chosen_card)
            end
          end
        end

        effect(:draw_for_each_blob_card_played_this_turn) do
          num = active_player.in_play.cards_in_play.count do |c|
            c.played_this_turn? && c.blob?
          end
          active_player.draw(num)
        end

        effect(:top_deck_next_ship) do
          sub = trade_row.on(:removing_card) do |zt|
            # active_turn.on(:end) { cancel }
            if zt.card.ship?
              zt.destination = active_player.draw_pile
              zt.destination_position = 0
              sub.cancel
            end
          end
        end

        # TODO: draw(2).when { active_player.in_play.count(&:base) >= 2 } ?
        effect(:draw_two_if_two_bases) do
          active_player.draw(2) if active_player.in_play.count(&:base?) >= 2
        end

        effect(:acquire_ship_and_top_deck) do
          trade_row_ships = trade_row.select(&:ship?)
          choose(trade_row_ships) do |card|
            active_player.acquire(card, zone: active_player.draw_pile, pos: 0)
          end
        end

        effect(:all_ships_get_combat, auto: true) do
          combat = in_play.on(:card_added) do |zt|
            if zt.card.ship?
              active_turn.combat += 1
            end
          end
          lifetime = in_play.on(:card_removed) do
            combat.cancel
            lifetime.cancel
          end 
        end

        effect(:copy_ship) do
          ships = in_play.select(&:ship?).index_by(&:key).except(card.key).values

          choose(ships) do |ship|
            card.definition = ship.definition.clone.tap do |definition|
              card.factions.each { |faction| definition.factions << faction }
            end
            perform Actions::PrimaryAbility.new(active_turn, card)
          end
        end
      end
    end
  end
end
