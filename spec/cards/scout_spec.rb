require "spec_helper"

RSpec.describe Realms2::Cards::Scout do
  let(:game) { Realms2::Game.new.start }
  let(:scout) { described_class.new(game.p1) }

  describe "#primary_ability" do
    before { scout.primary_ability.execute }
    it { expect(game.active_turn.trade).to eq(1) }
  end
end
