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
    module Config
      class Players
        attr_reader :zones, :resources

        def initialize
          @zones = {}
          @resources = {}
        end

        def resource(key, **kwargs)
          @resources[key] = Resource.new(key: key, shared: false, **kwargs)
        end

        def zone(key, **kwargs, &config)
          @zones[key] = Zone.new(key: key, shared: false, **kwargs)
        end

        def evaluate(context)
          Evaluated.new(self, context)
        end

        class Evaluated
          attr_reader :config, :context

          def initialize(config, context)
            @config = config
            @context = context
          end

          def zones
            @zones ||= players.each_with_object([]) do |player, zones|
              config.zones.each do |_, zone_config|
                zones << Layouts::Zone.new(owner: player, definition: zone_config)
              end
            end
          end

          def resources
            @resources ||= players.each_with_object([]) do |player, resources|
              config.resources.each do |_, resource_config|
                resources << Layouts::Resource.new(owner: player, definition: resource_config)
              end
            end
          end

          private

          # TODO: GameContext should define players
          Player = Struct.new(:key)
          def players
            [Player.new("p1"), Player.new("p2")]
          end
        end
      end

      class Shared
        attr_reader :zones, :resources

        def initialize
          @zones = {}
          @resources = {}
        end

        def zone(key, **kwargs)
          @zones[key] = Zone.new(key: key, shared: true, **kwargs)
        end

        def resource(key, default:)
          @resources[key] = Resource.new(key: key, default: default, shared: true)
        end

        def evaluate(context)
          Evaluated.new(self, context)
        end

        class Evaluated
          attr_reader :config, :context

          def initialize(config, context)
            @config = config
            @context = context
          end

          def zones
            @zones ||= config.zones.each_with_object([]) do |(_, zone_config), zones|
              zones << Layouts::Zone.new(owner: noone, definition: zone_config)
            end
          end

          def resources
            @resources ||= config.resources.each_with_object([]) do |(_, resource_config), resources|
              resources << Layouts::Resources.new(owner: noone, definition: resource_config)
            end
          end

          private

          Noone = Struct.new(:key)

          def noone
            @noone ||= Noone.new("shared")
          end
        end
      end

      class Zone
        attr_reader :key

        def initialize(key:, public: false, shared: false, ordered: false)
          @key = key
          @public = public
          @shared = shared
          @ordered = ordered
          @states = {}
        end

        def state(key, **kwargs)
          @states[key] = ZoneCardState.new(key: key, **kwargs)
        end

        def public?
          !!@public
        end

        def shared?
          !!@shared
        end

        def ordered?
          !!@ordered
        end
      end

      class Resource
        attr_reader :key, :default

        def initialize(key:, default:, shared: false)
          @key = key
          @default = default
          @shared = shared
        end

        def shared?
          !!@shared
        end
      end

      class ZoneCardState
        attr_reader :key, :default

        def initialize(key:, default:)
          @key = key
          @default = default
        end
      end
    end

    class Builder
      def self.build(&config)
        thing = new
        thing.instance_exec(&config)
        thing
      end

      attr_reader :perspectives

      def initialize
        @perspectives = {}
      end

      def players(&config)
        perspectives[:players] = Config::Players.new.tap do |players_config|
          players_config.instance_exec(&config) if block_given?
        end
      end

      def shared(&config)
        perspectives[:shared] = Config::Shared.new.tap do |shared_config|
          shared_config.instance_exec(&config) if block_given?
        end
      end

      # TODO: I think should just enforce all the config be unique at top level
      def item_definitions
        @item_definitions ||= perspectives.each_with_object([]) do |(key, config), all|
          config.zones.values.each do |z|
            all << z
          end
          config.resources.values.each do |r|
            all << r
          end
        end
      end

      def make(context)
        evaluated_shared = perspectives[:shared].evaluate(context)
        evaluated_players = perspectives[:players].evaluate(context)

        # TODO: any reason to keep them separate -- should we just enforce uniq keys
        Layouts::Layout.new(
          :zones => (evaluated_shared.zones + evaluated_players.zones).index_by(&:key),
          :resources => (evaluated_shared.resources + evaluated_players.resources).index_by(&:key)
        )
      end
    end

    def self.layout
      @layout ||= Builder.build do
        # TODO: add default card pools to zones

        shared do
          zone(:trade_deck)
          zone(:trade_row)
          zone(:explorers)
          zone(:scrap_heap)
        end

        players do
          resource(:trade, default: 0)
          resource(:combat, default: 0)
          resource(:authority, default: 50)

          # NOTE: push zone specific card state into card since the kind of state
          #       seems like it would vary based on the kind of card.
          #       Maybe there are defaults like age, played this turn, etc
          zone(:hand)
          zone(:in_play)
          zone(:discard_pile)
          zone(:draw_pile)
        end
      end
    end

    module Layouts
      class Layout
        attr_reader :zones, :resources

        def initialize(zones:, resources:)
          @zones = zones
          @resources = resources
        end

        def perspective(owner)
          perspectives.fetch(owner.key)
        end

        # TODO: get rid of the separation
        def items
          @items ||= zones.merge(resources)
        end

        def perspectives
          @perspectives ||= zones.values.map(&:owner).uniq.each_with_object({}) do |owner, all|
            all[owner.key] = Perspective.new(layout: self, owner: owner)
          end
        end

        class Perspective
          attr_reader :layout, :owner

          def initialize(layout:, owner:)
            @layout = layout
            @owner = owner
          end

          Zones.layout.item_definitions.each do |definition|
            if definition.shared?
              define_method(definition.key) do
                layout.items.fetch([:shared, definition.key].join("."))
              end
            else
              define_method(definition.key) do
                layout.items.fetch([owner.key, definition.key].join("."))
              end
            end
          end
        end
      end

      class Zone
        include Brainguy::Observer
        include Brainguy::Observable

        attr_reader :owner, :definition

        def initialize(owner:, definition:, cards: [])
          @owner = owner
          @definition = definition
          @cards = []
        end

        def key
          [owner.key, definition.key].join(".")
        end

        def inspect
          "<#{key} cards=#{cards}>"
        end

        # TODO: copy over other stuff from legacy Zone base class
      end

      class Resource
        attr_reader :owner, :definition

        def initialize(owner:, definition:)
          @owner = owner
          @definition = definition
        end

        def key
          [owner.key, definition.key].join(".")
        end
      end
    end
  end
end
