require "spec_helper"

RSpec.describe Realms::Cards::TradePod do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :blob
  include_examples "cost", 2

  describe "#primary_ability" do
    before { card.primary_ability.execute }
    it { expect(game.active_turn.trade).to eq(3) }
  end

  describe "#ally_ability" do
    it { expect { card.ally_ability.execute }.to change { game.active_turn.combat }.by(2) }
  end
end
