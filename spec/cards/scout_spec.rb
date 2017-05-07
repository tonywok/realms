require "spec_helper"

RSpec.describe Realms::Cards::Scout do
  include_examples "factions", :unaligned
  include_examples "cost", 0

  describe "#primary_ability" do
    include_examples "primary_ability"

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(1)
    }
  end
end
