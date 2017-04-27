require "spec_helper"

RSpec.describe Realms::Zones::Transfer do
  let(:owner) { Realms::Game.new.p1 }
  let(:destination) { Realms::Zones::Zone.new(owner, destination_cards) }
  let(:source) { Realms::Zones::Zone.new(owner, source_cards) }
  let(:zone_transfer) { described_class.new(source: source, destination: destination, card: card) }

  describe "#transfer!" do
    let(:card) { Realms::Cards::Scout.new(owner) }

    context "moving from source to destination" do
      let(:source_cards) { [card] }
      let(:destination_cards) { [] }

      it "moves from one zone to another" do
        expect(source).to include(card)
        expect(destination).to_not include(card)
        zone_transfer.transfer!
        expect(source).to_not include(card)
        expect(destination).to include(card)
      end
    end

    context "when the card isn't in the source" do
      let(:source_cards) { [] }
      let(:destination_cards) { [] }

      it { expect { zone_transfer.transfer! }.to raise_error(Realms::InvalidTarget) }
    end

    context "when the card is already in the destination" do
      let(:source_cards) { [card] }
      let(:destination_cards) { [card] }

      it { expect { zone_transfer.transfer! }.to raise_error(Realms::InvalidTarget) }
    end

    context "transferring to a specific position" do
      let(:card) { Realms::Cards::Scout.new(owner) }
      let(:source_cards) { [card] }
      let(:destination_cards) do
        [
          Realms::Cards::Scout.new(owner, index: 1),
          Realms::Cards::Scout.new(owner, index: 2),
          Realms::Cards::Scout.new(owner, index: 3),
          Realms::Cards::Scout.new(owner, index: 4),
        ]
      end

      it "removes from source and inserts into destination at pos" do
        zone_transfer.destination_position = 3
        zone_transfer.transfer!
        expect(source).to_not include(card)
        expect(destination.cards[3]).to eq(card)
      end
    end
  end
end
