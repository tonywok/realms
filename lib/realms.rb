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

# EXPERIMENT: start
require "thrones"
# EXPERIMENT: end

module Realms
  class InvalidTarget < StandardError; end
end
