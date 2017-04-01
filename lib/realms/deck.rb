require "realms/cards"

module Realms
  class Deck
    attr_accessor :draw_pile,
                  :hand,
                  :discard_pile,
                  :battlefield,
                  :player

    delegate :include?, to: :cards

    def initialize(player)
      @player = player
      scouts = 8.times.map { |i| Cards::Scout.new(player, index: i) }
      vipers = 2.times.map { |i| Cards::Viper.new(player, index: i) }
      @draw_pile = Zone.new(scouts + vipers)
      @discard_pile = Zone.new
      @hand = Zone.new
      @battlefield = Zone.new
    end

    def cards
      draw_pile.cards + discard_pile.cards + hand.cards + battlefield.cards
    end

    def discard(card)
      hand.transfer!(card: card, to: discard_pile)
    end

    def play(card)
      hand.transfer!(card: card, to: battlefield)
    end

    def destroy(card)
      battlefield.transfer!(card: card, to: discard_pile)
    end

    def acquire(card, zone: :discard_pile)
      card.player = player
      self.send(zone).unshift(card)
    end

    def scrap(card)
      raise(InvalidTarget, card) unless include?(card)
      # NOTE: so zone is a thing I need to extract
      zone = [draw_pile, discard_pile, hand, battlefield].find do |z|
        z.include?(card)
      end
      zone.delete(card)
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
      draw_pile.shuffle!
    end

    def inspect
      <<-DECK
      hand         : #{hand}
      draw_pile    : #{draw_pile}
      discard_pile : #{discard_pile}
      battlefield  : #{battlefield}
      DECK
    end
  end
end
