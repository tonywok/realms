require "bundler/setup"
require 'async/rspec'
require "pry"
Bundler.setup

require "realms"
include Realms

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
end
