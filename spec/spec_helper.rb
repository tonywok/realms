require "bundler/setup"
require "pry"
Bundler.setup

require "realms"

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
end
