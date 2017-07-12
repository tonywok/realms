require "spec_helper"

RSpec.describe Realms::Actions::AllyAbility do
  let(:game) { Realms::Game.new }

  context "when playing two different, same faction cards" do
    let(:card1) { Realms::Cards::BlobFighter.new(game.active_player) }
    let(:card2) { Realms::Cards::BattlePod.new(game.active_player) }

    before do
      game.active_player.deck.hand << card1
      game.active_player.deck.hand << card2
      game.start
    end

    it "triggers both cards" do
      game.play(card1)
      expect(game.current_choice.options).to_not have_key(:"ally_ability.blob_fighter_0")

      expect {
        game.play(card2)
        game.decide(game.trade_deck.trade_row.sample.key)
      }.to change { game.active_turn.combat }.by(6)

      expect { game.ally_ability(card1) }.to change { game.active_turn.active_player.deck.hand.length }.by(1)

      expect(game.current_choice.options).to_not have_key(:"ally_ability.blob_fighter_0")
      expect(game.current_choice.options).to_not have_key(:"ally_ability.battle_pod_0")
    end
  end

  context "when playing two of the same card" do
    let(:card1) { Realms::Cards::BlobFighter.new(game.active_player, index: 0) }
    let(:card2) { Realms::Cards::BlobFighter.new(game.active_player, index: 1) }

    before do
      game.active_player.deck.hand << card1
      game.active_player.deck.hand << card2
      game.start
    end

    it "triggers both cards once" do
      game.play(card1)
      game.play(card2)

      expect { game.ally_ability(card1) }.to change { game.active_turn.active_player.deck.hand.length }.by(1)
      expect { game.ally_ability(card2) }.to change { game.active_turn.active_player.deck.hand.length }.by(1)

      expect(game.current_choice.options).to_not have_key(:"ally_ability.blob_fighter_0")
      expect(game.current_choice.options).to_not have_key(:"ally_ability.blob_fighter_1")
    end
  end
end
