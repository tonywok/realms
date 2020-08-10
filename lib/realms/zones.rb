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
        attr_reader :zones, :resources, :transfers

        def initialize
          @zones = {}
          @resources = {}
          @transfers = {}
        end

        def resource(key, **kwargs)
          @resources[key] = Resource.new(key: key, shared: false, **kwargs)
        end

        def zone(key, **kwargs, &config)
          @zones[key] = Zone.new(key: key, public: false, shared: false, **kwargs)
        end

        def transfer(key, **kwargs)
          @transfers[key] = Transfer.new(key: key, **kwargs)
        end

        def evaluate(context)
          evaluated_zones = players.each_with_object([]).with_index do |(player, all_zones), player_index|
            zones.each do |_, zone_config|
              pool = case zone_config.key
                     when :draw_pile then CardPools::StarterDeck.cards
                     else
                       []
                     end
              cards = pool.each_with_object([]) do |(klass, num), cards|
                num.times { |count| cards << klass.new(player, index: count + (num * player_index)) }
              end
              all_zones << Layouts::Zone.new(owner: player, definition: zone_config, cards: cards)
            end
          end
          evaluated_resources = players.each_with_object([]) do |player, all_resources|
            resources.each do |_, resource_config|
              all_resources << Layouts::Resource.new(owner: player, definition: resource_config)
            end
          end

          Evaluated.new(self, evaluated_zones, evaluated_resources)
        end

        private

        # TODO: GameContext should define players
        Player = Struct.new(:key)
        def players
          [Player.new("p1"), Player.new("p2")]
        end

        class Evaluated
          attr_reader :config, :zones, :resources

          def initialize(config, zones, resources)
            @config = config
            @zones = zones
            @resources = resources
          end
        end
      end

      class Shared
        attr_reader :zones, :resources, :transfers

        def initialize
          @zones = {}
          @resources = {}
          @transfers = {}
        end

        def zone(key, **kwargs)
          @zones[key] = Zone.new(key: key, ordered: true, public: true, shared: true, **kwargs)
        end

        def resource(key, default:)
          @resources[key] = Resource.new(key: key, default: default, shared: true)
        end

        def transfer(key, **kwargs)
          @transfers[key] = Transfer.new(key: key, **kwargs)
        end

        def evaluate(context)
          evaluated_zones = zones.each_with_object([]) do |(_, zone_config), all_zones|
            pool = case zone_config.key
                   when :trade_deck then CardPools::Vanilla.cards
                   when :explorers then CardPools::Explorers.cards
                   else
                     []
                   end

            cards = pool.each_with_object([]) do |(klass, num), cards|
              num.times { |count| cards << klass.new(noone, index: count) }
            end
            # TODO: Evaluate zone config
            all_zones << Layouts::Zone.new(owner: noone, definition: zone_config, cards: cards)
          end

          evaluated_resources = resources.each_with_object([]) do |(_, resource_config), all_resources|
            all_resources << Layouts::Resources.new(owner: noone, definition: resource_config)
          end

          Evaluated.new(self, evaluated_zones, evaluated_resources)
        end

        private

        Noone = Struct.new(:key)

        def noone
          @noone ||= Noone.new("shared")
        end

        class Evaluated
          attr_reader :config, :zones, :resources

          def initialize(config, zones, resources)
            @config = config
            @zones = zones
            @resources = resources
          end
        end
      end

      class Zone
        attr_reader :key, :max

        def initialize(key:, public: false, shared: false, ordered: false, max: Float::INFINITY)
          @key = key
          @public = public
          @shared = shared
          @ordered = ordered
          @states = {}
          @handlers = Hash.new([])
          @max = max
        end

        def state(key, **kwargs)
          @states[key] = ZoneCardState.new(key: key, **kwargs)
        end

        def on(event, &handler)
          handlers[event] << handler
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

      class Transfer
        attr_reader :key, :from, :to, :shared

        def initialize(key:,from:, to:, shared: false)
          @key = key
          @from = from
          @to = to
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
          config.transfers.values.each do |t|
            all << t
          end
        end
      end

      def make(context)
        evaluated_shared = perspectives[:shared].evaluate(context)
        evaluated_players = perspectives[:players].evaluate(context)

        # TODO: any reason to keep them separate -- should we just enforce uniq keys
        Layouts::Layout.new(
          :context => context,
          :zones => (evaluated_shared.zones + evaluated_players.zones).index_by(&:key),
          :resources => (evaluated_shared.resources + evaluated_players.resources).index_by(&:key)
        )
      end
    end

    def self.layout
      @layout ||= Builder.build do
        shared do
          zone(:trade_deck, public: false)
          zone(:trade_row, max: 5) do
            on(:card_removed) { transfer(from: trade_deck) }
          end
          zone(:explorers)
          zone(:scrap_heap)

          transfer(:draw, from: :draw_pile, to: :hand)
          transfer(:play, from: :hand, to: :in_play)
        end

        players do
          resource(:trade, default: 0)
          resource(:combat, default: 0)
          resource(:authority, default: 50) do
            on(:zero, &:game_over!)
          end

          zone(:hand, ordered: false)
          zone(:in_play, ordered: false, public: true) do
            # on(:card_added) do
            #   perform(card.primary_ability(turn) if card.automatic_primary_ability?
            #   active_player.in_play.actions.select(&:auto?).each do |action|
            #     perform(action)
            #   end
            # end
          end
          zone(:discard_pile)
          zone(:draw_pile) do
            # on(:empty) { transfer_all(from: discard_pile, shuffle: true) }
          end

          transfer(:draw, from: :draw_pile, to: :hand)
          transfer(:play, from: :hand, to: :in_play)
          transfer(:discard, from: :hand, to: :discard_pile)
          transfer(:destroy, from: :in_play, to: :discard_pile) 
          transfer(:acquire, from: :trade_row, to: :discard_pile)
          transfer(:scrap, from: :anywhere, to: :scrap_heap)
        end
      end
    end

    module Layouts
      class Layout
        attr_reader :context, :zones, :resources

        delegate :game,
          to: :context

        delegate :active_turn, :choose,
          to: :game

        def initialize(context:, zones:, resources:)
          @context = context
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

        # TODO: nope, not this
        def players
          items.values.map(&:owner).uniq.select { |a| a.is_a?(Config::Players::Player) }
        end

        def perspectives
          @perspectives ||= zones.values.map(&:owner).uniq.each_with_object({}) do |owner, all|
            all[owner.key] = Perspective.new(layout: self, owner: owner)
          end
        end

        Zones.layout.item_definitions.select(&:shared?).each do |definition|
          define_method(definition.key) do
            items.fetch([:shared, definition.key].join("."))
          end
        end

        class Perspective
          attr_reader :layout, :owner

          delegate :key,
            to: :owner

          def initialize(layout:, owner:)
            @layout = layout
            @owner = owner
          end

          Zones.layout.item_definitions.reject(&:shared?).each do |definition|
            case definition
            when Config::Zone, Config::Resource
              define_method(definition.key) do
                layout.items.fetch([owner.key, definition.key].join("."))
              end
            when Config::Transfer
              define_method(definition.key) do |card_or_num|
                sender = public_send(definition.from)
                receiver = public_send(definition.to)
                case card_or_num
                when Integer
                  card_or_num.times { sender.transfer!(to: receiver) }
                when Realms::Cards::Card
                  sender.transfer!(card: card_or_num, to: receiver)
                else
                  raise "wut"
                end
              end
            else
              raise "wut"
            end
          end
        end
      end

      class Zone
        include Brainguy::Observer
        include Brainguy::Observable

        attr_reader :owner, :definition, :cards

        delegate :include?, :shuffle!, :empty?, :first, :last, :length, :sample, :index, :insert,
          :select, :each,
          to: :cards

        def initialize(owner:, definition:, cards: [])
          @owner = owner
          @definition = definition
          @cards = cards
        end

        def key
          [owner.key, definition.key].join(".")
        end

        def inspect
          "<#{key} cards=#{cards}>"
        end

        def transfer!(card: first, to:, pos: to.length)
          zt = Realms::Zones::Transfer.new(card: card, source: self, destination: to, destination_position: pos)

          emit(:removing_card, zt)
          zt.transfer!
          emit(:card_removed, zt)
          to.send(:emit, :card_added, zt)
        end

        def remove(card)
          cards.delete_at(cards.index(card) || cards.length)
        end
      end

      class Resource
        attr_reader :owner, :definition, :value

        delegate :positive?,
          to: :value

        def initialize(owner:, definition:)
          @owner = owner
          @definition = definition
          @value = definition.default
        end

        def key
          [owner.key, definition.key].join(".")
        end
      end
    end
  end
end
