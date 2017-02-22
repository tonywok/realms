require "spec_helper"

RSpec.describe Realms::Cards::BattlePod do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:blob) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(2) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.decide(:play, :battle_pod_0)
    end

    it "adds 4 combat and prompts the player to scrap a card from the trade row" do
      expect(game.active_turn.combat).to eq(4)
      expect(game.current_choice.options.keys).to contain_exactly(*game.trade_deck.trade_row.map(&:key).uniq)
      card = game.trade_deck.trade_row.last
      expect {
        game.decide(card.key)
      }.to change { game.trade_deck.trade_row }
      expect(game.trade_deck.trade_row).to_not include(card)
      expect(game.trade_deck.trade_row.length).to eq(5)
    end
  end

  describe "#ally_ability" do
    before { game.start }
    it {
      expect {
        card.ally_ability.new(game.active_turn).execute
      }.to change { game.active_turn.combat }.by(2)
    }
  end
end
