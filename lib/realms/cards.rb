require "realms/cards/definition"
require "realms/cards/dsl"
require "realms/cards/card"

Dir[File.expand_path('../cards/*.rb', __FILE__)].each do |file|
  require file
end

module Realms
  module Cards
  end
end
