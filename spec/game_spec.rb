require "spec_helper"

RSpec.describe Realms2::Game do
  it "plays" do
    game = described_class.new
    game.start
    game.decide(:play_card)
    game.decide(:scout)
    game.decide(:play_card)
    game.decide(:scout)
    game.decide(:end_turn)
  end
end
