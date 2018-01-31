## notes
# 1. zone isn't a state machine
# 2. automatic should be a concern of the ability
# 3. zones just send back actions
# 4. in play card state kept in sync with observation
#
module Realms
  module Zones
    class InPlay < Zone
      class CardState
        class State
          STATES = [
            INELIGIBLE = "ineligible",
            ELIGIBLE   = "eligible",
            AVAILABLE  = "available",
            EXHAUSTED  = "exhausted",
          ]

          attr_reader :state

          def initialize(card_state)
            @card_state = card_state
            reset!
          end

          def reset!
            self.state = get_state
          end

          def refresh!
            return EXHAUSTED if exhausted?
            reset!
          end

          def exhaust!
            self.state = EXHAUSTED
          end

          def exhausted?
            state == EXHAUSTED
          end

          def available?
            state == AVAILABLE
          end

          def inspect
            "<#{self.class} state=#{state}>"
          end

          private

          attr_reader :card_state
          attr_writer :state
        end

        class Primary < State
          def get_state
            return AVAILABLE if card_state.primary_ability?
            byebug
            INELIGIBLE
          end
        end

        class Ally < State
          def get_state
            return AVAILABLE if ally_available?
            return ELIGIBLE if card_state.ally_ability?
            INELIGIBLE
          end

          private

          def ally_available?
            return false unless card_state.ally_ability?
            card_state.owner.in_play.cards.any? { |other| card_state.ally?(other) }
          end
        end

        attr_reader :card, :primary, :ally

        delegate_missing_to :card

        def initialize(card)
          @card = card
          @played_this_turn = true
          @primary = Primary.new(self)
          @ally = Ally.new(self)
        end

        def actions(turn)
          [].tap do |actions|
            actions << Actions::PrimaryAbility.new(turn, card) if primary.available?
            actions << Actions::AllyAbility.new(turn, card) if ally.available?
            actions << Actions::ScrapAbility.new(turn, card) if scrap_ability?
          end
        end

        def played_this_turn?
          @played_this_turn
        end

        def refresh!
          primary.refresh!
          ally.refresh!
        end

        def reset!
          @played_this_turn = false
          primary.reset!
          ally.reset!
        end
      end
    end
  end
end
