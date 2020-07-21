module Realms
  module TurnStructure
    def self.registry
      @registry ||= Builder.build do
        phase(:setup) do
          trade_deck.setup
          active_player.draw(3)
          passive_player.draw(5)
        end

        loop(:players) do
          phase(:upkeep)

          phase(:main) do
            # TODO: probabaly move to layout
            actions = active_player.actions +
                      passive_player.in_play.actions +
                      trade_deck.actions +
                      [Actions::EndMainPhase.new(active_turn)]
            choose(actions) do |action|
              perform(action)
              execute unless action.is_a?(Actions::EndMainPhase)
            end
          end

          phase(:discard) do
            # TODO: move trade/combat state to layout
            active_turn.trade = 0
            active_turn.combat = 0
            active_player.in_play.select(&:ship?).each do |ship|
              active_player.destroy(ship)
            end
            active_player.discard_hand
          end

          phase(:draw) do
            active_player.draw(5)
            active_player.in_play.reset!
            # TODO: Probably remove turn as a thing that needs interacted with
            game.send(:next_turn)
          end
        end
      end
    end

    class Builder
      attr_reader :kind, :declarations

      def self.sequence
        new(kind: Declarations::Sequence)
      end

      def self.modal
        new(kind: Declarations::Modal)
      end

      def self.loop
        new(kind: Declarations::Loop)
      end

      def self.build(kind: Abilities::Declarations::Sequence, &block)
        builder = new(kind: kind)
        builder.instance_exec(&block)
        builder.to_definition
      end

      def initialize(kind:)
        @kind = kind
        @declarations = []
      end

      def phase(key, &execution)
        definition = PhaseDefinition.new(key: key, execution: execution)
        declarations << Declarations::Phase.new(definition: definition)
      end

      def loop(key, &block)
        loop_builder = self.class.loop
        loop_builder.instance_exec(&block)
        declarations << Declarations::Loop.new(key: key, declarations: loop_builder.declarations)
      end

      def choose(&block)
        modal_builder = self.class.modal
        modal_builder.instance_exec(&block)
        declarations << Abilities::Declarations::Modal.new(:declarations => modal_builder.declarations)
      end

      def to_definition
        Structure.new(:declaration => Abilities::Declarations::Sequence.new(declarations: declarations))
      end

      class Structure
        attr_reader :declaration

        def initialize(declaration:)
          @declaration = declaration
        end

        def evaluate(context)
          Evaluated.new(declaration, context)
        end

        class Evaluated
          attr_reader :declaration, :context

          def initialize(declaration, context)
            @declaration = declaration
            @context = context
          end

          def on_beginning_of(phase:, forx:, &handler)
            event = [forx.key, phase, :beginning].join(":").to_sym
            context.on(event, &handler)
          end

          def execute
            declaration.evaluate(context).execute
          end
        end
      end

      class PhaseDefinition
        attr_reader :key, :execution

        def initialize(key:, execution:)
          @key = key
          @execution = execution
        end
      end

      module Declarations
        class Phase
          attr_reader :definition

          def initialize(definition:)
            @definition = definition
          end

          def evaluate(context)
            Evaluated.new(self, context)
          end

          class Evaluated
            attr_reader :declaration, :context

            delegate :game, :card, to: :context
            delegate :choose, :perform, :active_turn, :active_player, :passive_player, :trade_deck, to: :game
            delegate :trade_row, to: :trade_deck
            delegate :in_play, to: :active_player

            def initialize(declaration, context)
              @declaration = declaration
              @context = context
            end

            def execute
              event = [active_player.key, declaration.definition.key].join(":")
              beginning = [event, :beginning].join(":").to_sym
              ending = [event, :ending].join(":").to_sym

              context.emit(beginning)
              instance_exec(&declaration.definition.execution) if declaration.definition.execution
              context.emit(ending)
            end
          end
        end

        class Loop
          attr_reader :key, :declarations

          def initialize(key:, declarations:)
            @key = key
            @declarations = declarations
          end

          def evaluate(context)
            Evaluated.new(self, context)
          end

          class Evaluated
            attr_reader :declaration, :context

            delegate :game, :card, to: :context
            delegate :perform, :active_turn, :active_player, :passive_player, :trade_deck, to: :game
            delegate :trade_row, to: :trade_deck
            delegate :in_play, to: :active_player

            def initialize(declaration, context)
              @declaration = declaration
              @context = context
            end

            def execute
              declaration.declarations.cycle do |declaration|
                phase = declaration.evaluate(context) 
                game.perform(phase)
              end
            end
          end
        end
      end
    end
  end
end