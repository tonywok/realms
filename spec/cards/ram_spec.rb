require "spec_helper"

RSpec.describe Realms::Cards::Ram do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :blob
  include_examples "cost", 3

  describe "#primary_ability" do
    it { expect { card.primary_ability.execute }.to change { game.active_turn.combat }.by(5) }
  end

  describe "#ally_ability" do
    it { expect { card.ally_ability.execute }.to change { game.active_turn.combat }.by(2) }
  end

  describe "#scrap_ability" do
    it { expect { card.scrap_ability.execute }.to change { game.active_turn.trade }.by(3) }
  end
end
