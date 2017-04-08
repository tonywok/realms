require "realms/actions/action"

Dir[File.expand_path('../actions/*.rb', __FILE__)].each do |file|
  require file
end

module Realms
  module Actions
  end
end
