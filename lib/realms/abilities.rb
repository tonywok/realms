require "realms/abilities/ability"

Dir[File.expand_path('../abilities/*.rb', __FILE__)].each do |file|
  require file
end

module Realms
  module Abilities
  end
end
