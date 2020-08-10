module Realms
  module Turns
    class Structure
      attr_reader :declaration

      def initialize(declaration:)
        @declaration = declaration
      end

      def evaluate(layout)
        Evaluated.new(declaration, layout)
      end

      class Evaluated
        attr_reader :declaration, :layout

        delegate :game,
          :to => :layout

        include Brainguy::Observer
        include Brainguy::Observable

        def initialize(declaration, layout)
          @declaration = declaration
          @layout = layout
        end

        def emit(*args)
          super(*args)
        end

        def once(phase, player:, &handler)
          event = [player.key, phase].join(":").to_sym
          sub = layout.on(event) do
            handler.call
            sub.cancel
          end
        end

        def active_player
          layout.perspective(layout.game.active_turn.active_player)
        end

        def passive_players
          [layout.game.active_turn.passive_player].map { |p| layout.perspective(p) }
        end

        def perform(*args)
          layout.game.perform(*args)
        end

        def execute
          declaration.evaluate(self).execute
        end
      end
    end
  end
end