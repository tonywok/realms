require "spec_helper"

RSpec.describe Realms2::Game do
  it "plays" do
    game = described_class.new
    game.next_choice
    game.decide(:end_turn)
    game.decide(:end_turn)
  end
end
