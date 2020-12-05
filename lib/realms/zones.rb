require "realms/zones/registry"
require "realms/zones/zone"
require "realms/zones/null"
require "realms/zones/trade_row"
require "realms/zones/explorers"
require "realms/zones/hand"
require "realms/zones/in_play"
require "realms/zones/discard_pile"
require "realms/zones/draw_pile"
require "realms/zones/scrap_heap"

module Realms
  module Zones
    def self.registry
      @registry ||= Registry.configure do
        perspective(:player) do
          zone(:hand, Hand, public: false, shared: false, ordered: false)
          zone(:in_play, InPlay, public: false, shared: false, ordered: false)
          zone(:discard_pile, DiscardPile, public: true, shared: false, ordered: false)
          zone(:draw_pile, DrawPile, public: false, shared: false, ordered: false)

          resource(:trade, public: true, shared: false, default: 0)
          resource(:combat, public: true, shared: false, default: 0)
          resource(:authority, public: true, shared: false, default: 50)
        end

        perspective(:shared) do
          zone(:trade_deck, TradeDeck, public: false, shared: true, ordered: true)
          zone(:trade_row, TradeRow, public: true, shared: true, ordered: true)
          zone(:explorers, Explorers, public: true, shared: true, ordered: true)
        end
      end
    end
  end
end

# Does a layout have perspectives?
# Is a layout just all the perspectives combined?
# Can we make a layout from the registry or should it be freeform?
# Maybe we can provide default perspectives and you can always subclass to hack something in?
class Layout
  def self.make(players)
  end

  def zones
    @zones ||= perspectives.each_with_object({}) do |perspective, all|
      all.merge!(perspective.zones.index_by(&:key)) do
        raise("#{key} is already registered")
      end
    end
  end

  module Perspectives
    class Player
      attr_reader :layout, :player
      attr_accessor :authority, :trade, :combat

      delegate *Zones.registry.shared_zones.map(&:key), to: :layout

      def initialize(layout:, player:)
        @layout = layout
        @player = player
        @combat = 0
        @trade = 0
        @authority = 50
        @zones = Zones.registry.make_player_zones(owner: player)
      end
    end

    class Shared
      class Noone; end

      attr_reader :layout, :zones

      def initialize
        @layout = layout
        @zones = Zones.registry.make(owner: Noone.new)
      end
    end
  end
end