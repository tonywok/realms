require "realms/player"
require "realms/trade_deck"
require "realms/card_pools"

module Realms
  module Zones
    class Registry
      attr_reader :game, :rng, :p1, :p2, :trade_deck

      include Brainguy::Observer

      def initialize(game)
        @game = game
        @rng = Random.new(game.seed)
        @starter_deck = StarterDeck.new
        @p1 = Player.new("p1", self)
        @p2 = Player.new("p2", self)
        @trade_deck = TradeDeck.new(self)
      end

      def zone(key)
        registry.fetch(key)
      end

      def register!
        register_players
        register_trade_deck
      end

      def on_card_added(event)
        zt = event.args[0]
        game.publish(:zone_transfer, card: zt.card.key, source: zt.source.key, destination: zt.destination.key)
      end

      private

      attr_reader :game,
        :starter_deck,
        :registry

      delegate :viper, :scout,
        to: :starter_deck

      delegate :active_turn,
        to: :game

      def registry
        @registry ||= {}
      end

      def register(zone_klass, owner:, cards: [])
        zone = zone_klass.new(self, owner, cards)
        registry[zone.key] = zone
      end

      def register_trade_deck
        register(DrawPile, owner: trade_deck, cards: card_pool(trade_deck))
        register(ScrapHeap, owner: trade_deck)
        register(TradeRow, owner: trade_deck)
        register(Explorers, owner: trade_deck)
      end

      def register_players
        register_player(p1)
        register_player(p2)
      end

      def register_player(player)
        register(DrawPile, owner: player, cards: starting_deck(player))
        register(DiscardPile, owner: player)
        register(Hand, owner: player)
        register(InPlay, owner: player)
      end

      def starting_deck(player)
        scouts = 8.times.map { scout(player) }
        vipers = 2.times.map { viper(player) }
        (scouts + vipers).shuffle(random: rng)
      end

      def card_pool(trade_row)
        CardPools::Vanilla.cards.each_with_object([]) do |(klass, num), cards|
          num.times do |i|
            cards << klass.new(trade_row, index: i)
          end
        end
      end

      class StarterDeck
        def initialize
          @scout_count = 0
          @viper_count = 0
        end

        def scout(player)
          Cards::Scout.new(player, index: scout_count).tap do
            @scout_count += 1
          end
        end

        def viper(player)
          Cards::Viper.new(player, index: viper_count).tap do
            @viper_count += 1
          end
        end

        private

        attr_reader :scout_count, :viper_count
      end
    end
  end
end
