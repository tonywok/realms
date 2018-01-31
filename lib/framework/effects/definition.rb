require "realms/yielder"
require "realms/abilities/ability"

module Framework
  module Effects
    class Definition
      attr_reader :effect_class, :num, :effects

      delegate :auto?, to: :effect_class

      def initialize(effect_class, num)
        @effect_class = effect_class
        @num = num
        @effects = []
      end

      def auto?
        true
      end

      def static?
        false
      end

      def to_effect(card, turn)
        effect_class[num].new(self, card, turn)
      end

      def trade(num)
        effects << self.class.new(Trade, num)
      end

      def combat(num)
        effects << self.class.new(Combat, num)
      end

      def authority(num)
        effects << self.class.new(Authority, num)
      end

      def choose(&block)
        # TODO: more specific effect definitions
        effect = self.class.new(Choice, nil)
        effect.instance_exec(&block)
        effects << effect
      end
    end

    class Effect < ::Realms::Abilities::Ability
      attr_reader :definition
      delegate :effects, :num, to: :definition

      def initialize(definition, card, turn)
        @definition = definition
        super(card, turn)
      end

      def self.auto?
        false
      end

      def self.static?
        false
      end
    end

    class Authority < Effect
      def execute
        turn.active_player.authority += arg
      end

      def self.auto?
        true
      end
    end

    class Trade < Effect
      def execute
        turn.trade += num
      end

      def self.auto?
        true
      end
    end

    class Combat < Effect
      def execute
        turn.combat += num
      end

      def self.auto?
        true
      end
    end

    class Choice < Effect
      def execute
        choose(effects) do  |effect|
          perform effect.to_effect(card, turn)
        end
      end
    end

    class Sequence < Effect
      def execute
        effects.each do |effect|
          perform effect.to_effect(card, turn)
        end
      end
    end
  end
end
