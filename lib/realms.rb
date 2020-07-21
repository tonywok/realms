require "realms/version"
require "active_support/all"
require "brainguy"
require "realms/flows"
require "realms/choices"
require "realms/effects"
require "realms/abilities"
require "realms/actions"
require "realms/cards"
require "realms/game"

module Realms
  class InvalidTarget < StandardError; end
  class GameOver < StandardError; end
end
