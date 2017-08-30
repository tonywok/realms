require "spec_helper"

RSpec.describe Realms::Actions::BaseAbility do
  let(:game) { Realms::Game.new }
  let(:action) { described_class.new(card) }

  context "automatically triggered base abilities" do
    let(:card) { Realms::Cards::BlobWheel.new(game.active_player) }

    context "playing a base" do
      before do
        game.p1.hand << card
        game.start
      end

      it "automatically uses primary ability" do
        expect {
          game.play(card)
        }.to change { game.active_turn.combat }.by(1)
      end

      it "cannot perform primary base ability again once automatically triggered" do
        expect {
          game.play(card)
        }.to change { game.active_turn.combat }.by(1)
        expect { game.base_ability(card) }.to raise_error(Realms::Choice::InvalidOption)
      end
    end

    context "a base in play" do
      it "automatically uses primary ability"
      it "cannot perform primary base ability again once automatically triggered"
    end
  end

  context "manually executed base abilities" do
    let(:card) { Realms::Cards::TradingPost.new(game.active_player) }

    context "playing a base" do
      before do
        game.p1.hand << card
        game.start
      end

      it "must be explicitly chosen" do
        game.play(card)
        expect {
          game.base_ability(card)
          game.decide(:"trading_post.authority")
        }.to change { game.active_player.authority }.by(1)
      end
    end

    context "a base in play" do
      before do
        game.p1.in_play << card
        game.start
      end

      it "must be explicitly chosen" do
        game.base_ability(card)
        expect {
          game.decide(:"trading_post.authority")
        }.to change { game.active_player.authority }.by(1)
      end

      it "can only be used once" do
        game.base_ability(card)
        expect {
          game.decide(:"trading_post.trade")
        }.to change { game.active_turn.trade }.by(1)
        expect { game.base_ability(card) }.to raise_error(Realms::Choice::InvalidOption)
      end
    end
  end
end
