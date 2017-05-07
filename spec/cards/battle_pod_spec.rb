require "spec_helper"

RSpec.describe Realms::Cards::BattlePod do
  include_examples "factions", :blob
  include_examples "cost", 2

  describe "#primary_ability" do
    include_context "primary_ability"

    it "adds 4 combat and prompts the player to scrap a card from the trade row" do
      expect { game.play(card) }.to change { game.active_turn.combat }.by(4)
      expect(game.current_choice.options.keys).to contain_exactly(*game.trade_deck.trade_row.map(&:key).uniq, :none)
      trade_row_card = game.trade_deck.trade_row.last
      expect { game.decide(trade_row_card.key) }.to change { game.trade_deck.trade_row }
      expect(game.trade_deck.trade_row).to_not include(trade_row_card)
      expect(game.trade_deck.trade_row.length).to eq(5)
    end

    context "opting out of optional primary ability" do
      it "can opt out of optional abilities" do
        expect { game.play(card) }.to change { game.active_turn.combat }.by(4)
        expect(game.current_choice.options).to have_key(:none)
        expect {
          game.decide(:none)
        }.to_not change { game.trade_deck.trade_row.length }
      end
    end
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::BlobFighter

    it {
      expect {
        game.decide(:none)
        game.ally_ability(card)
      }.to change { game.active_turn.combat }.by(2)
    }
  end
end
