module Realms
  module Flows
    module Declarations
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
            @active_declaration = nil
          end

          # TODO: There's probably a "round" that uses loop
          def execute
            context.layout.players.cycle do |active_player|
              declaration.declarations.each do |declaration|
                phase = declaration.evaluate(context, active_player) 
                game.perform(phase)
              end
            end
          end
        end
      end
    end
  end
end