require "realms/cards"

module Realms
  class Deck
    attr_accessor :draw_pile,
                  :hand,
                  :discard_pile,
                  :in_play,
                  :player,
                  :zones,
                  :trade_row,
                  :scrap_heap

    def initialize(player)
      @player = player
      @zones = [
        @draw_pile = Zones::Zone.new(player, starting_deck),
        @discard_pile = Zones::DiscardPile.new(player),
        @hand = Zones::Hand.new(player),
        @in_play = Zones::InPlay.new(player),
      ]
    end

    def discard(card)
      hand.transfer!(card: card, to: discard_pile)
    end

    def play(card)
      hand.transfer!(card: card, to: in_play)
    end

    def destroy(card)
      in_play.transfer!(card: card, to: discard_pile)
    end

    def acquire(card, zone: discard_pile, pos: 0)
      trade_row.transfer!(card: card, to: zone, pos: pos)
    end

    def scrap(card)
      card.zone.transfer!(card: card, to: scrap_heap)
    end

    def discard_hand
      until hand.empty?
        discard(hand.first)
      end
    end

    def draw
      if draw_pile.empty?
        reshuffle
        draw unless draw_pile.empty?
      else
        draw_pile.transfer!(to: hand)
      end
    end

    def reshuffle
      until discard_pile.empty? do
        discard_pile.transfer!(to: draw_pile)
      end
      draw_pile.shuffle!(random: player.game.rng)
    end

    private

    def starting_deck
      scouts = 8.times.map { |i| Cards::Scout.new(player, index: i) }
      vipers = 2.times.map { |i| Cards::Viper.new(player, index: i) }
      (scouts + vipers).shuffle(random: player.game.rng)
    end

    # TODO: zone registry for easier access
    def trade_row
      player.game.trade_deck.trade_row
    end

    def scrap_heap
      player.game.trade_deck.scrap_heap
    end
  end
end
