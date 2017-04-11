require "spec_helper"

RSpec.describe Realms::Cards::FleetHQ do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :base
  include_examples "defense", 8
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 8

  # NOTE: http://www.starrealms.com/faq/
  #
  describe "#primary_ability" do
    let(:viper_0) { Realms::Cards::Viper.new(game.p1, index: 10) }
    let(:viper_1) { Realms::Cards::Viper.new(game.p1, index: 11) }
    let(:scout_0) { Realms::Cards::Scout.new(game.p1, index: 10) }
    let(:scout_1) { Realms::Cards::Scout.new(game.p1, index: 11) }
    let(:scout_2) { Realms::Cards::Scout.new(game.p1, index: 12) }

    let(:hand) do
      Realms::Zones::Hand.new(game.p1, [
        viper_0,
        viper_1,
        scout_0,
        scout_1,
        scout_2,
      ])
    end

    before do
      game.p1.deck.hand = hand
      game.p1.hand << card
      game.start
    end

    it "adds one combat to all ships played after fleet hq" do
      expect { game.play(viper_0) }.to change { game.active_turn.combat }.by(1)
      expect { game.play(scout_0) }.to change { game.active_turn.combat }.by(0)
      game.play(card)
      expect { game.play(scout_1) }.to change { game.active_turn.combat }.by(1)
      expect { game.play(scout_2) }.to change { game.active_turn.combat }.by(1)
      expect { game.play(viper_1) }.to change { game.active_turn.combat }.by(2)
      expect(game.active_turn.combat).to eq(5)
      game.end_turn
    end
  end
end
