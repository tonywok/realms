require "spec_helper"

RSpec.describe Realms::Card2 do
  describe "defaults" do
    before do
      class SomeCard < described_class; end
    end
    let(:card) { SomeCard.new }

    describe "#faction" do
      subject { card.faction }
      it { is_expected.to eq(:unaligned) }
    end

    describe "#cost" do
      subject { card.cost }
      it { is_expected.to eq(0) }
    end
  end

  describe "overriding defaults" do
    before do
      class SomeCard < described_class
        cost 1
        faction :blob
      end
    end
    let(:card) { SomeCard.new }

    describe "#faction" do
      subject { card.faction }
      it { is_expected.to eq(:blob) }
    end

    describe "#cost" do
      subject { card.cost }
      it { is_expected.to eq(1) }
    end
  end
end
