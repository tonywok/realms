module Realms
  module Turns
    module Declarations
      class Phase
        attr_reader :definition

        def initialize(definition:)
          @definition = definition
        end

        def evaluate(structure, active_player)
          Evaluated.new(self, structure, active_player)
        end

        class Evaluated
          attr_reader :declaration, :structure, :active_player

          delegate :game, :layout, :passive_players,
            to: :structure
          delegate :choose, :perform, :active_turn, :passive_player, to: :game
          delegate :in_play, to: :active_player

          def initialize(declaration, structure, active_player)
            @declaration = declaration
            @structure = structure
            @active_player = active_player
          end

          def eligible_actions
            action_defs = Actions.actions.slice(*declaration.definition.actions)
            action_defs.values.each_with_object([]) do |action_def, actions|
              instance_exec(&action_def.targeting).each do |target|
                action = action_def.evaluate(structure, target)
                actions << action if action.eligible?
              end
            end
          end

          def execute
            event = [active_player.key, declaration.definition.key].join(":")
            beginning = [event, :beginning].join(":").to_sym
            ending = [event, :ending].join(":").to_sym

            structure.emit(beginning)
            instance_exec(&declaration.definition.execution) if declaration.definition.execution
            structure.emit(ending)
          end
        end
      end
    end
  end
end