require "spec_helper"

RSpec.describe Realms::Cards::Viper do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :unaligned
  include_examples "cost", 0

  describe "#primary_ability" do
    before { card.primary_ability.execute }
    it { expect(game.active_turn.combat).to eq(1) }
  end
end
