
Dir[File.expand_path('../refactor/*.rb', __FILE__)].each do |file|
  require file
end

module Realms
  module Refactor
  end
end