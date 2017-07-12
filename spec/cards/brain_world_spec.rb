require "spec_helper"

RSpec.describe Realms::Cards::BrainWorld do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.active_player) }

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
        game.active_player.deck.hand.concat(Array.wrap(hand))
        game.active_player.deck.discard_pile.concat(Array.wrap(discard_pile))
        game.active_player.deck.in_play.concat(Array.wrap(in_play))
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
        expect { game.decide(:none) }.to_not change { game.active_player.deck.hand.length }
      end
    end

    context "scrap 1 card from hand" do
      let(:card_from_hand) { game.active_player.deck.hand.sample }

      it "draws 1 card" do
        expect {
          game.decide(card_from_hand.key)
          game.decide(:none)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_hand)
        }.to change { game.active_player.deck.draw_pile.length }.by(-1)
      end
    end

    context "scrap 1 card from discard pile" do
      let(:discard_pile) { [Realms::Cards::Cutter.new(game.active_player)] }
      let(:card_from_discard_pile) { discard_pile.first }

      it "draws 1 card" do
        expect {
          game.decide(card_from_discard_pile.key)
          game.decide(:none)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_discard_pile)
        }.to change { game.active_player.deck.draw_pile.length }.by(-1)
      end
    end

    context "scrap 2 cards from hand" do
      let(:card_from_hand_0) { game.active_player.deck.hand.first }
      let(:card_from_hand_1) { game.active_player.deck.hand.second }

      it "draws 1 card" do
        expect {
          game.decide(card_from_hand_0.key)
          game.decide(card_from_hand_1.key)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_hand_0, card_from_hand_1)
        }.to change { game.active_player.deck.draw_pile.length }.by(-2)
      end
    end

    context "scrap 2 cards from discard pile" do
      let(:discard_pile) { [Realms::Cards::Cutter.new(game.active_player), Realms::Cards::FederationShuttle.new(game.active_player)] }

      it "draws 2 cards" do
        expect {
          game.decide(discard_pile.first.key)
          game.decide(discard_pile.second.key)
          expect(game.trade_deck.scrap_heap).to contain_exactly(*discard_pile)
        }.to change { game.active_player.deck.draw_pile.length }.by(-2)
      end
    end

    context "scrap 1 card from hand, 1 card from discard pile" do
      let(:discard_pile) { [card_from_discard_pile] }
      let(:card_from_discard_pile) { Realms::Cards::Cutter.new(game.active_player) }
      let(:card_from_hand) { game.active_player.deck.hand.first }

      it "draws 2 cards" do
        expect {
          game.decide(card_from_discard_pile.key)
          game.decide(card_from_hand.key)
          expect(game.trade_deck.scrap_heap).to contain_exactly(card_from_discard_pile, card_from_hand)
        }.to change { game.active_player.deck.draw_pile.length }.by(-2)
      end
    end
  end
end
