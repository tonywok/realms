require "bundler/setup"
require "byebug"
Bundler.setup

require "realms"

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
end
