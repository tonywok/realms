require "realms/abilities"
require "realms/actions"

module Realms
  module Cards
    class Card
      attr_accessor :player
      attr_reader :key

      def initialize(player = Player::Unclaimed.instance, index: 0)
        @player = player
        @key = "#{self.class.to_s.demodulize.underscore}_#{index}".to_sym
      end

      def inspect
        key
      end

      def base?
        false
      end

      def ally_ability_activated?
        return false if faction == :unaligned
        (player.deck.battlefield - [self]).any? { |card| card.faction == faction }
      end

      def self.cost(trade)
        define_method(:cost) do
          trade
        end
      end

      def self.faction(name)
        define_method(:faction) do
          name
        end
      end

      def self.primary_ability(*klasses)
        define_method(:primary_ability) do
          klass = if klasses.many?
                    Abilities::Multi[klasses]
                  else
                    klasses.first
                  end
          klass.new(player.active_turn)
        end
      end

      def self.ally_ability(klass)
        define_method(:ally_ability) do
          klass.new(player.active_turn)
        end
      end

      def self.scrap_ability(klass)
        define_method(:scrap_ability) do
          klass.new(player.active_turn)
        end
      end
    end
  end
end
