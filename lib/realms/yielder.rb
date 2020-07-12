require "realms/choices"

module Realms
  class Yielder
    module Gutted
      delegate :game, to: :turn
      delegate :choose, :may_choose, :choose_many, :may_choose_many, :perform, to: :game
    end
  end
end
