module Realms
  module Zones
    class InPlay < Zone
      class CardState
        attr_reader :card
        attr_accessor :primary_used, :ally_used, :played_this_turn

        delegate_missing_to :card

        def initialize(card)
          @card = card
          @primary_used = false
          @ally_used = false
          @played_this_turn = true
        end

        alias_method :primary_used?, :primary_used
        alias_method :ally_used?, :ally_used
        # maybe make this private and ask the zone for cards played this turn
        # then we wouldn't have to have CardInPlay exposed externally
        alias_method :played_this_turn?, :played_this_turn

        def primary_available?
          return false unless primary_ability?
          !primary_used?
        end

        def auto_primary_available?
          return false if primary_used?
          ship? ? true : automatic_primary_ability?
        end

        def primary_ability(turn)
          super(turn).tap { self.primary_used = true }
        end

        def ally_ability(turn)
          super(turn).tap { self.ally_used = true }
        end

        def reset!
          self.primary_used = false
          self.ally_used = false
          self.played_this_turn = false if base?
        end
      end
    end
  end
end
