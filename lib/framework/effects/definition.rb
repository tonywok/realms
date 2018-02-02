require "realms/yielder"
require "realms/abilities/ability"

module Framework
  module Effects
    class Definition
      attr_reader :effect_class, :num, :effects, :optionality

      delegate :auto?, to: :effect_class

      def initialize(effect_class, num, optionality: false)
        @effect_class = effect_class
        @num = num
        @effects = []
        @optionality = optionality
      end

      def static?
        false
      end

      def to_effect(card, turn)
        effect_class.new(self, card, turn, optional: optionality)
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

      def draw(num)
        effects << self.class.new(Draw, num)
      end

      def discard(num = 1)
        effects << self.class.new(Discard, num)
      end

      def scrap_card_from_hand_or_discard_pile(optional: false)
        effects << self.class.new(ScrapCardFromHandOrDiscardPile, nil, optionality: optional)
      end

      def scrap_card_from_trade_row(optional: false)
        effects << self.class.new(ScrapCardFromTradeRow, nil, optionality: optional)
      end

      def destroy_target_base(optional: false)
        effects << self.class.new(DestroyTargetBase, nil, optionality: optional)
      end

      def choose(&block)
        # TODO: more specific effect definitions
        effect = self.class.new(Choose, nil)
        effect.instance_exec(&block)
        effects << effect
      end
    end

    class Effect < Realms::Yielder
      include Brainguy::Observer

      attr_reader :definition, :card, :turn, :optional

      delegate :effects, :num, to: :definition
      delegate :active_player, :trade_deck, to: :turn

      class << self
        def auto?
          false
        end

        def static?
          false
        end
      end

      def initialize(definition, card, turn, optional: false)
        @definition = definition
        @card = card
        @turn = turn
        @optional = optional
      end

      def key
        self.class.name.demodulize.underscore.to_s
      end

      def choose(options, subject: key, optionality: optional, **kwargs)
        super
      end
    end

    class Authority < Effect
      def execute
        turn.active_player.authority += num
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

    class Draw < Effect
      def execute
        turn.active_player.draw(num)
      end
    end

    class Discard < Effect
      def execute
        turn.passive_player.upkeep << ::Realms::Actions::Discard
      end
    end

    class Choose < Effect
      def execute
        choices = effects.map { |e| e.to_effect(card, turn) }
        # TODO: card name probably shouldn't be the subject
        choose(choices, subject: card.name) do  |effect|
          perform effect
        end
      end
    end

    class ScrapCardFromHandOrDiscardPile < Effect
      def execute
        choose(cards_in_hand_or_discard_pile, optionality: optional) do |card|
          active_player.scrap(card)
        end
      end

      private

      def cards_in_hand_or_discard_pile
        active_player.hand.cards + active_player.discard_pile.cards
      end
    end

    class ScrapCardFromTradeRow < Effect
      def execute
        choose(cards_in_trade_row, optionality: optional) do |card|
          active_player.scrap(card)
        end
      end

      private

      def cards_in_trade_row
        trade_deck.trade_row.cards
      end
    end

    class DestroyTargetBase < Effect
      def execute
        choose(bases_in_play) do |card|
          player = card.owner
          player.destroy(card)
        end
      end

      def bases_in_play
        all_bases = turn.active_player.in_play.select(&:base?) +
          turn.passive_player.in_play.select(&:base?)
        all_bases.any?(&:outpost?) ? all_bases.select(&:outpost?) : all_bases
      end
    end

    class Sequence < Effect
      def execute
        effects.each do |effect|
          perform effect.to_effect(card, turn)
        end
      end
    end

    # TODO figure out optional vs automatic
    #      optional + automatic = automatic?
    class PrimaryAbility < Sequence
    end

    class AllyAbility < Sequence
    end

    class ScrapAbility < Sequence
    end
  end
end
