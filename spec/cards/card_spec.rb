require "spec_helper"

RSpec.describe Realms::Cards::Card do
  describe "defaults" do
    before do
      class SomeCard < described_class; end
    end

    include_examples "factions", [] do
      let(:card) { SomeCard.new("test") }
    end

    include_examples "cost", 0 do
      let(:card) { SomeCard.new("test") }
    end
  end

  describe "overriding defaults" do
    before do
      class SomeCard < described_class
        cost 1
        faction :blob
      end
    end
    let(:card) { SomeCard.new("test") }

    include_examples "factions", :blob do
      let(:card) { SomeCard.new("test") }
    end
    include_examples "cost", 1 do
      let(:card) { SomeCard.new("test") }
    end
  end

  describe "shuffling" do
    let(:unshuffled) { 10.times.map { |i| Realms::Cards::Scout.new(index: i) } }
    let(:seed) { Random.new_seed }

    it "shuffles the same with a seed" do
      shuffled = unshuffled.shuffle(random: Random.new(seed))
      expect(unshuffled.shuffle(random: Random.new(seed))).to eq(shuffled)
    end
  end
end
