require "realms2/abilities"
require "realms2/actions"

module Realms2
  module Cards
    class Card
      attr_accessor :player
      attr_reader :key

      def initialize(player = Player::Unclaimed.instance)
        @player = player
        @key = self.class.to_s.demodulize.underscore.to_sym
      end

      def inspect
        key
      end

      def self.cost(trade)
        define_method(:cost) do
          trade
        end
      end

      def self.faction(name)
        define_method(:faction) do
          name || :unaligned
        end
      end

      def self.primary_ability(klass)
        define_method(:primary_ability) do
          klass.new(player)
        end
      end

      def self.ally_ability(klass)
        define_method(:ally_ability) do
          klass.new(player)
        end
      end

      def self.scrap_ability(klass)
        define_method(:scrap_ability) do
          klass.new(player)
        end
      end
    end
  end
end
