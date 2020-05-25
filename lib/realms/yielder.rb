require "realms/choices"

module Realms
  class Yielder
    module Gutted
      delegate :game, to: :turn
      delegate :choose, :may_choose, :choose_many, :may_choose_many, :perform, to: :game

      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Callbacks

        define_callbacks :execute
        set_callback :execute, :after, :notify


        def __execute
          run_callbacks :execute do
            execute
          end
        end

        def notify; end
      end
    end
  end
end
