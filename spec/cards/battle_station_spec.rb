require "spec_helper"

RSpec.describe Realms::Cards::BattleStation do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 5
  include_examples "factions", :machine_cult
  include_examples "cost", 3

  describe "#scrap_ability" do
    it { expect { card.scrap_ability.execute }.to change { game.active_turn.combat }.by(5) }
  end
end
