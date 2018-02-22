require "realms/effects/definitions"
require "realms/effects/effect"
require "realms/effects/sequence"
require "realms/effects/numeric"
require "realms/effects/custom"

Dir[File.expand_path('../effects/*.rb', __FILE__)].each do |file|
  require file
end

module Realms
  module Effects
  end
end
