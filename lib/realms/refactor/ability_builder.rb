require_relative "ability_definition"
require_relative "effect_registry"

module Realms
  module Refactor
    class AbilityBuilder
      attr_reader :kind, :declarations

      def self.sequence
        new(kind: Declarations::Sequence)
      end

      def self.modal
        new(kind: Declarations::Modal)
      end

      def initialize(kind:)
        @kind = kind
        @declarations = []
      end

      def self.effect_registry
        @effect_registry ||= EffectRegistry.configure do
          effect(:trade) do |amount|
            active_turn.trade += amount
          end

          effect(:combat) do |amount|
            active_turn.combat += amount
          end

          effect(:authority) do |amount|
            active_player.authority += amount
          end

          effect(:draw, auto: false) do |amount|
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
            choose(trade_deck.trade_row.cards, count: 1, optionality: optional) do
              active_player.scrap(card)
            end
          end
        end
      end

      effect_registry.registrations.each do |effect_key, effect_definition|
        define_method(effect_key) do |amount = nil, optional: false|
          declarations << Declarations::Effect.new(definition: effect_definition, amount: amount, optional: optional)
        end
      end

      def choose(&block)
        modal_builder = self.class.modal
        modal_builder.instance_exec(&block)
        declarations << Declarations::Modal.new(:declarations => modal_builder.declarations)
      end

      def to_definition
        # Spell Ability - just the words on the text
        #   Sequence
        #   Choice
        #   
        # Activitated Ability - has a cost (e.g scrap)
        # Triggered Ability - happens when something else happens (usually for a duration)
        # Static Ability - abilities that just are
        #
        #  FleetHQ has a triggered ability that gives ships that enter play +1 combat
        #  It has been errata'd to say "Whenever you play a ship, gain {1 combat}"
        #
        Ability.new(:declaration => Declarations::Sequence.new(declarations: declarations))
      end

      private

      class Ability
        attr_reader :declaration

        def initialize(declaration:)
          @declaration = declaration
        end

        def evaluate(context)
          declaration.evaluate(context)
        end

        def auto?
          declaration.auto?
        end
      end

      module Declarations
        class Effect
          attr_reader :definition, :amount, :optional

          delegate :auto?, :key,
            to: :definition

          def initialize(definition:, amount:, optional: false)
            @definition = definition
            @amount = amount
            @optional = optional
          end

          def evaluate(context)
            Evaluated.new(declaration: self, context: context)
          end

          class Evaluated
            attr_reader :context, :declaration

            delegate :game, to: :context
            delegate :active_turn, :active_player, :passive_player, to: :game

            delegate :definition, :optional, to: :declaration
            delegate :auto?, to: :definition

            def initialize(context:, declaration:)
              @context = context
              @declaration = declaration
            end

            def choose(options, **kwargs, &block)
              game.choose(options, optionality: declaration.optional, subject: declaration.key, **kwargs, &block)
            end

            def __execute
              instance_exec(declaration.amount, &declaration.definition.execution)
            end
          end
        end

        class Sequence
          attr_reader :declarations

          def initialize(declarations:)
            @declarations = declarations
          end

          def evaluate(context)
            Evaluated.new(self, context)
          end

          def auto?
            declarations.all?(&:auto?)
          rescue => e
            binding.pry
            raise
          end

          class Evaluated
            attr_reader :declaration, :context

            delegate :game, to: :context

            def initialize(declaration, context)
              @declaration = declaration
              @context = context
            end

            def __execute
              declaration.declarations.each do |declaration|
                effect = declaration.evaluate(context) 
                game.perform(effect)
              end
            end
          end
        end

        class Modal
          attr_reader :declarations

          def initialize(declarations:)
            @declarations = declarations
          end

          def evaluate(context)
            Evaluated.new(self, context)
          end

          delegate :game, to: :context

          def auto?
            false
          end

          class Evaluated
            attr_reader :declaration, :context

            delegate :game, to: :context
            delegate :choose, to: :game
            delegate :active_turn, :active_player, :passive_player, to: :game

            def initialize(declaration, context)
              @declaration = declaration
              @context = context
            end

            def __execute
              choose(declaration.declarations, subject: context.card.name) do |declaration|
                effect = declaration.evaluate(context) 
                game.perform(effect)
              end
            end
          end
        end
      end
    end
  end
end