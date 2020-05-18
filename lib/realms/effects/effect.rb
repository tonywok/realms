module Realms
  module Effects
    class Effect
      include Brainguy::Observer

      attr_reader :definition, :card, :turn, :optional

      delegate :effects, to: :definition
      delegate :active_player, :trade_deck, :publish, to: :turn

      include Yielder::Gutted

      class << self
        def auto?
          false
        end
      end

      def initialize(definition, card, turn, optional: false)
        @definition = definition
        @card = card
        @turn = turn
        @optional = optional
      end

      def auto?
        effects.all?(&:auto?)
      end

      def key
        self.class.name.demodulize.underscore.to_s
      end

      def choose(options, subject: key, optionality: optional, **kwargs, &block)
        game.choose(options, subject: subject, optionality: optionality, **kwargs, &block)
      end
    end
  end
end
