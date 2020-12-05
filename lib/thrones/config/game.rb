module Thrones
  class Game < Realms::Game
    module Structure
      module Declarations
        class InPlayerOrder
          attr_reader :declarations

          def initialize(declarations:)
            @declarations = declarations
          end

          def evaluate(layout)
            Evaluated.new(self, layout)
          end

          class Evaluated
            attr_reader :declaration, :layout

            def initialize(declaration, layout)
              @declaration = declaration
              @layout = layout
            end
          end
        end

        class Phase
          attr_reader :name, :declarations

          def initialize(name:, declarations:)
            @name = name
            @declarations = declarations
          end

          def evaluate(layout)
            Evaluated.new(self, layout)
          end

          class Evaluated
            attr_reader :declaration, :layout

            def initialize(declaration, layout)
              @declaration = declaration
              @layout = layout
            end
          end
        end

        class Step
          attr_reader :name, :declarations

          def initialize(name:, declarations:)
            @name = name
            @declarations = declarations
          end

          def evaluate(layout)
            Evaluated.new(self, layout)
          end

          class Evaluated
            attr_reader :declaration, :layout

            def initialize(declaration, layout)
              @declaration = declaration
              @layout = layout
            end
          end
        end
      end

      class Builder
        include Realms::Flows::Builder

        def self.phase
          new(kind: Declarations::Phase)
        end

        def self.step
          new(kind: Declarations::Step)
        end

        def self.in_player_order
          new(kind: Declarations::InPlayerOrder)
        end

        def phase(key, &block)
          phase_builder = self.class.phase
          phase_builder.instance_exec { step(:"#{key}_start") }
          phase_builder.instance_exec(&block) if block_given?
          phase_builder.instance_exec { step(:"#{key}_end") }
          declarations << Declarations::Phase.new(name: key, declarations: phase_builder.declarations)
        end

        def step(key, &block)
          step_builder = self.class.step
          step_builder.instance_exec(&block) if block_given?
          declarations << Declarations::Step.new(name: key, declarations: step_builder.declarations)
        end

        def in_player_order(&block)
          in_player_order_builder = self.class.sequence
          in_player_order_builder.instance_exec(&block)
          declarations << Declarations::InPlayerOrder.new(declarations: in_player_order_builder.declarations)
        end

        def to_definition
          binding.pry
        end
      end
    end

    def self.structure(&block)
      @structure ||= Structure::Builder.build(&block)
    end
  end
end