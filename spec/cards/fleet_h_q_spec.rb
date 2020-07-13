require "spec_helper"

RSpec.describe Realms::Cards::FleetHQ do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.active_player) }

  include_examples "type", :base
  include_examples "defense", 8
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 8

  # NOTE: http://www.starrealms.com/faq/
  #
  describe "#primary_ability" do
    let(:viper_0) { game.p1.viper }
    let(:viper_1) { game.p1.viper }
    let(:scout_0) { game.p1.scout }
    let(:scout_1) { game.p1.scout }
    let(:scout_2) { game.p1.scout }

    let(:hand) do
      [
        viper_0,
        viper_1,
        scout_0,
        scout_1,
        scout_2,
      ]
    end

    before do
      hand.each do |c|
        game.p1.hand << c
      end
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

      # kill fleethq
      #
      dreadnaught = Realms::Cards::Dreadnaught.new(game.active_player)
      some_card = game.active_player.hand.sample
      game.active_player.hand << dreadnaught
      game.play(some_card)
      expect {
        game.play(dreadnaught)
        game.scrap_ability(dreadnaught)
      }.to change { game.active_turn.combat }.by(12)
      game.attack(card)
      expect(card.zone).to eq(game.passive_player.discard_pile)


      # Check to see that fleet hq isn't still active
      #
      scout = Realms::Cards::Scout.new(game.passive_player, index: 10)
      game.passive_player.hand << scout
      game.end_turn

      expect { game.play(scout) }.not_to change { game.active_turn.combat }
    end
  end
end
