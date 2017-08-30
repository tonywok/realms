require "spec_helper"

RSpec.describe Realms::Cards::BattleBlob do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.active_player) }

  include_examples "factions", :blob
  include_examples "cost", 6

  describe "#primary_ability" do
    include_context "primary_ability"
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(8) }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BlobFighter
    it { expect { game.ally_ability(card) }.to change { game.active_player.hand.length }.by(1) }
  end

  describe "#scrap_ability" do
    include_context "scrap_ability"
    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(4) }
  end
end
