require "spec_helper"

RSpec.describe Realms::Cards::BrainWorld do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", :machine_cult
  include_examples "cost", 8

  def self.setup(desc, &example_group_block)
    let(:hand) { [] }
    let(:discard_pile) { [] }
    let(:in_play) { [] }

    example_group_class = context desc do
      before do
        game.p1.hand.concat(Array.wrap(hand))
        game.p1.discard_pile.concat(Array.wrap(discard_pile))
        game.p1.in_play.concat(Array.wrap(in_play))
        game.start
        game.play(card)
        game.base_ability(card)
      end
    end

    example_group_class.class_eval(&example_group_block)
  end

  setup "base_ability" do
    let(:hand) { card }

    context "scrap no cards" do
      it "draws no cards" do
        expect { game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, :none) }.to_not change { game.active_player.hand.length }
      end
    end

    context "scrap 1 card from hand" do
      let(:card_from_hand) { game.p1.hand.sample }

      it "draws 1 card" do
        expect {
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, card_from_hand)
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, :none)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_hand)
        }.to change { game.active_player.draw_pile.length }.by(-1)
      end
    end

    context "scrap 1 card from discard pile" do
      let(:discard_pile) { [Realms::Cards::Cutter.new(game.p1)] }
      let(:card_from_discard_pile) { discard_pile.first }

      it "draws 1 card" do
        expect {
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, card_from_discard_pile)
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, :none)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_discard_pile)
        }.to change { game.active_player.draw_pile.length }.by(-1)
      end
    end

    context "scrap 2 cards from hand" do
      let(:card_from_hand_0) { game.active_player.hand.first }
      let(:card_from_hand_1) { game.active_player.hand.second }

      it "draws 1 card" do
        expect {
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, card_from_hand_0)
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, card_from_hand_1)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_hand_0, card_from_hand_1)
        }.to change { game.active_player.draw_pile.length }.by(-2)
      end
    end

    context "scrap 2 cards from discard pile" do
      let(:discard_pile) { [Realms::Cards::Cutter.new(game.p1), Realms::Cards::FederationShuttle.new(game.p1)] }

      it "draws 2 cards" do
        expect {
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, discard_pile.first)
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, discard_pile.second)
          expect(game.trade_deck.scrap_heap).to contain_exactly(*discard_pile)
        }.to change { game.active_player.draw_pile.length }.by(-2)
      end
    end

    context "scrap 1 card from hand, 1 card from discard pile" do
      let(:discard_pile) { [card_from_discard_pile] }
      let(:card_from_discard_pile) { Realms::Cards::Cutter.new(game.p1) }
      let(:card_from_hand) { game.p1.hand.first }

      it "draws 2 cards" do
        expect {
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, card_from_discard_pile)
          game.decide(:draw_for_each_scrap_from_hand_or_discard_pile, card_from_hand)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_discard_pile, card_from_hand)
        }.to change { game.active_player.draw_pile.length }.by(-2)
      end
    end
  end
end
