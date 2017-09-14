require_relative "choices/choice"
require_relative "choices/multi_choice"
require_relative "choices/option"
require_relative "choices/factory"

module Realms
  module Choices
    class InvalidOption < StandardError; end

    class Choice
    end
  end
end
