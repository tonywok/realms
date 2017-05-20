module Realms
  module Sets
    class Vanilla
      include Cards

      def self.cards
        @cards ||= {}
      end

      def self.card(klass, num)
        cards[klass] = num
      end

      attr_reader :cards

      def initialize(trade_deck)
        @cards = self.class.cards.each_with_object([]) do |(klass, num), cards|
          num.times do |i|
            cards << klass.new(trade_deck, index: i)
          end
        end
      end

      # Machine Cult
      card TradeBot, 3
      card MissileBot, 3
      card SupplyBot, 3
      card PatrolMech, 2
      card StealthNeedle, 1
      card BattleMech, 1
      card MissileMech, 1
      card BattleStation, 2
      card MechWorld, 1
      card BrainWorld, 1
      card MachineBase, 1
      card Junkyard, 1

      # Star Empire
      card ImperialFighter, 3
      card ImperialFrigate, 3
      card SurveyShip, 3
      card Corvette, 2
      card Battlecruiser, 1
      card Dreadnaught, 1
      card SpaceStation, 2
      card RecyclingStation, 2
      card WarWorld, 1
      card RoyalRedoubt, 1
      card FleetHQ, 1

      # Trade Federation
      card FederationShuttle, 3
      card Cutter, 3
      card EmbassyYacht, 2
      card Freighter, 2
      card CommandShip, 1
      card TradeEscort, 1
      card Flagship, 1
      card TradingPost, 2
      card BarterWorld, 2
      card DefenseCenter, 1
      card CentralOffice, 1
      card PortOfCall, 1

      # Blob
      card BlobFighter, 3
      card TradePod, 3
      card BattlePod, 2
      card Ram, 2
      card BlobDestroyer, 2
      card BattleBlob, 1
      card BlobCarrier, 1
      card Mothership, 1
      card BlobWheel, 3
      card TheHive, 1
      card BlobWorld, 1
    end
  end
end
