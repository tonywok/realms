require "realms/version"
require "active_support/all"
require "brainguy"
require "realms/yielder"
require "realms/effects"
require "realms/actions"
require "realms/cards"
require "realms/game"
require "realms/stack"

module Realms
  class InvalidTarget < StandardError; end
end
